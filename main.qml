import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Person {
    id: alice

    name: 'Alice'
    listdata: [
        ['G', 'random number', '', 'Gen', 'Send'],
        ['P', 'random number', '', 'Gen', 'Send'],
        ['a', 'random number', '', 'Gen', ''],
        ['xa', '(G^a) mod P', '', 'Calc', ''],
        ['na', 'p * q', '', 'Calc', 'Send'],
        ['ea', 'Generate by rules', '', 'Gen', 'Send'],
        ['da', 'ea^-1 mod y(n)', '', 'Calc', ''],
        ['nb', 'Recieve from Bob', '', '', ''],
        ['eb', 'Recieve from Bob', '', '', ''],
        ['Cxa', '(xa ^ eb) mod nb', '', 'Calc', 'Div'],
        ['Cxa1', 'Result from divide', '', 'Send', ''],
        ['Cxb1', 'Recieve from Bob', '', 'Calc', ''],
        ['Cxa2', 'Result from divide', '', 'Send', ''],
        ['Cxb2', 'Recieve from Bob', '', 'Calc', ''],
        ['Cxb', 'Cxb1 + Cxb2', '', 'Calc', ''],
        ['xb', '(Cxb ^ da) mod na', '', 'Calc', ''],
        ['K', '(xb ^ a) mod P', '', 'Calc', '']
    ]

    Person {
        id: bob
        name: 'Bob'
        listdata: [
            ['G', 'random number', '', '', ''],
            ['P', 'random number', '', '', ''],
            ['b', 'random number', '', 'Gen', ''],
            ['na', 'Recieve from Alice', '', '', ''],
            ['ea', 'Recieve from Alice', '', '', ''],
            ['xb', '(G^b) mod P', '', 'Calc', ''],
            ['nb', 'p * q', '', 'Calc', 'Send'],
            ['eb', 'Generate by rules', '', 'Gen', 'Send'],
            ['db', 'eb^-1 mod y(n)', '', 'Calc', ''],
            ['Cxb', '(xb ^ ea) mod na', '', 'Calc', 'Div'],
            ['Cxa1', 'Recieve from Alice', '', 'Send', ''],
            ['Cxb1', 'Result from divide', '', 'Calc', ''],
            ['Cxa2', 'Recieve from Alice', '', 'Send', ''],
            ['Cxb2', 'Result from divide', '', 'Calc', ''],
            ['Cxa', 'Cxa1 + Cxa2', '', 'Calc', ''],
            ['xa', '(Cxa ^ db) mod nb', '', 'Calc', ''],
            ['K', '(xa ^ b) mod P', '', 'Calc', '']
        ]
    }

    function check_do_1(index, name) {
        if (name == 'Alice')
        {
            // Alice first button
            if (alice.step == 0) // G
            {
                model.setProperty(index, '_res', generate(4));
                _g = model.get(index)._res;
            }
            else if (alice.step == 1) // P
            {
                model.setProperty(index, '_res', generate(16));
                _p = model.get(index)._res;
            }
            else if (alice.step == 2) // a
            {
                model.setProperty(index, '_res', generate(4));
                _ab = model.get(index)._res;
                next_items(1, 'Alice');
            }
            else if (alice.step == 3) // xa
            {
                model.setProperty(index, '_res', solve_x(_g, _ab, _p));
                _x = model.get(index)._res;
                next_items(1, 'Alice');
            }
            else if (alice.step == 4) // na
            {
                model.setProperty(index, '_res', 'SOLVE na');
                _n = model.get(index)._res;
            }
            else if (alice.step == 5) // ea
            {
                model.setProperty(index, '_res', 'SOLVE ea');
                _e = model.get(index)._res;
            }
            else if (alice.step == 6) // da
            {
                model.setProperty(index, '_res', 'SOLVE da');
                _d = model.get(index)._res;
                next_items(1, 'Alice');
            }
        }
        else
        {
            // Bob first button
            if (bob.step == 2)
            {
                bob.model.setProperty(index, '_res', generate(128));
                bob._ab = bob.model.get(index)._res;
                next_items(1, 'Bob');
            }
            else if (bob.step == 5) // xb
            {
                bob.model.setProperty(index, '_res', solve_x(bob._g, bob._ab, bob._p));
                bob._x = bob.model.get(index)._res;
                next_items(1, 'Bob');
            }
            else if (bob.step == 6) // nb
            {
                bob.model.setProperty(index, '_res', 'SOLVE nb');
                bob._n = bob.model.get(index)._res;
            }
            else if (bob.step == 7) // eb
            {
                bob.model.setProperty(index, '_res', 'SOLVE eb');
                bob._e = bob.model.get(index)._res;
            }
            else if (bob.step == 8) // db
            {
                bob.model.setProperty(index, '_res', 'SOLVE db');
                bob._d = bob.model.get(index)._res;
                next_items(1, 'Bob');
            }
        }
    }

    // Second button
    function check_do_2(index, name) {
        if (name == 'Alice')
        {
            // Second button Alice
            if (bob.step == 0)
            {
                bob.model.setProperty(index, '_res', _g);
                bob._g = _g;
                next_items(1, 'Bob');
                next_items(1, 'Alice');
            }
            else if (bob.step == 1)
            {
                bob.model.setProperty(index, '_res', _p);
                bob._p = _p;
                next_items(1, 'Bob');
                next_items(1, 'Alice');
            }
            else if ([3, 4].includes(bob.step))
            {
                bob.model.setProperty(index, '_res', model.get(0)._res);
                next_items(1, 'Bob');
                next_items(1, 'Alice');   
            }
        }
        else
        {
            // Second button Bob
            if (alice.step == 7 || alice.step == 8)
            {
                model.setProperty(index, '_res', bob.model.get(0)._res);
                next_items(1, 'Bob');
                next_items(1, 'Alice');
            }
        }
    }

    function next_items(count, name) {
        if (name == 'Alice') var temp = alice;
        else temp = bob;
        for (var i = 0; i < count; i++){ temp.model.remove(0); temp.next_item(); }
    }

    function generate(l) {
        var res = '1';
        for (var i = 0; i < l-1; i++) res += String(Math.round(Math.random()));
        return res;
    }

    function solve_x(_g, _l, _p) {
        _g = Number.parseInt(_g, 2);
        _l = Number.parseInt(_l, 2);
        _p = Number.parseInt(_p, 2);
        var res = ((_g ** _l) % _p).toString(2);
        return res;
    }

    function solve_n(_g, _l, _p) {
        _g = Number.parseInt(_g, 2);
        _l = Number.parseInt(_l, 2);
        _p = Number.parseInt(_p, 2);
        var res = ((_g ** _l) % _p).toString(2);
        return res;
    }
}