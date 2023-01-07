package;

class CursorType {


    public static function construct(cursors:FlxTypedGroup<FlxObject>, number:Int) {
        for (i in 0...cursors.members.length){
            cursors.members[i].exists = false;
        }

        // ...
    }

    public static function setType(cursors:FlxTypedGroup<FlxObject>, type:Int) {

        for (i in 0...cursors.members.length){
            cursors.members[i].exists = false;
        }

        switch(type) {
            case 1:
                cursors.members[12].exists = true;
            case 2:
                cursors.members[12].exists = true;
                cursors.members[13].exists = true;
            case 3:
                cursors.members[7].exists = true;
                cursors.members[12].exists = true;
            case 4:
                cursors.members[7].exists = true;
                cursors.members[11].exists = true;
                cursors.members[13].exists = true;
            case 5:
                cursors.members[6].exists = true;
                cursors.members[12].exists = true;
                cursors.members[8].exists = true;
            case 6:
                cursors.members[6].exists = true;
                cursors.members[12].exists = true;
                cursors.members[16].exists = true;
            case 7:
                cursors.members[8].exists = true;
                cursors.members[12].exists = true;
                cursors.members[18].exists = true;
            case 8:
                cursors.members[11].exists = true;
                cursors.members[12].exists = true;
                cursors.members[18].exists = true;
            case 9:
                cursors.members[11].exists = true;
                cursors.members[12].exists = true;
                cursors.members[8].exists = true;
            case 10:
                cursors.members[16].exists = true;
                cursors.members[12].exists = true;
                cursors.members[13].exists = true;
            case 11:
                cursors.members[6].exists = true;
                cursors.members[12].exists = true;
                cursors.members[13].exists = true;
            case 12:
                cursors.members[11].exists = true;
                cursors.members[12].exists = true;
                cursors.members[13].exists = true;
            case 13:
                cursors.members[7].exists = true;
                cursors.members[12].exists = true;
                cursors.members[17].exists = true;
        }
    }

    static public function rotateLeft(cursors:FlxTypedGroup<FlxObject>) {
        var newPositions = new Array<Int>();

        for (i in 0...cursors.members.length) {
            if (!cursors.members[i].exists) continue;
            
            switch (i) {
                case 0:
                    newPositions.push(4);
                case 1:
                    newPositions.push(9);
                case 2:
                    newPositions.push(14);
                case 3:
                    newPositions.push(19);
                case 4:
                    newPositions.push(24);
                case 5:
                    newPositions.push(3);
                case 6:
                    newPositions.push(8);
                case 7:
                    newPositions.push(13);
                case 8:
                    newPositions.push(18);
                case 9:
                    newPositions.push(23);
                case 10:
                    newPositions.push(2);
                case 11:
                    newPositions.push(7);
                case 12:
                    newPositions.push(12);
                case 13:
                    newPositions.push(17);
                case 14:
                    newPositions.push(22);
                case 15:
                    newPositions.push(1);
                case 16:
                    newPositions.push(6);
                case 17:
                    newPositions.push(11);
                case 18:
                    newPositions.push(16);
                case 19:
                    newPositions.push(21);
                case 20:
                    newPositions.push(0);
                case 21:
                    newPositions.push(5);
                case 22:
                    newPositions.push(10);
                case 23:
                    newPositions.push(15);
                case 24:
                    newPositions.push(20);

            }
        }

        for (i in 0...cursors.members.length){
            cursors.members[i].exists = false;
        }

        for (i in 0...newPositions.length) {
            cursors.members[newPositions[i]].exists = true;
        }
    }

    static public function rotateRight(cursors:FlxTypedGroup<FlxObject>) {
        var newPositions = new Array<Int>();

        for (i in 0...cursors.members.length) {
            if (!cursors.members[i].exists) continue;
            
            switch (i) {
                case 0:
                    newPositions.push(20);
                case 1:
                    newPositions.push(15);
                case 2:
                    newPositions.push(10);
                case 3:
                    newPositions.push(5);
                case 4:
                    newPositions.push(0);
                case 5:
                    newPositions.push(21);
                case 6:
                    newPositions.push(16);
                case 7:
                    newPositions.push(11);
                case 8:
                    newPositions.push(6);
                case 9:
                    newPositions.push(1);
                case 10:
                    newPositions.push(22);
                case 11:
                    newPositions.push(17);
                case 12:
                    newPositions.push(12);
                case 13:
                    newPositions.push(7);
                case 14:
                    newPositions.push(2);
                case 15:
                    newPositions.push(23);
                case 16:
                    newPositions.push(18);
                case 17:
                    newPositions.push(13);
                case 18:
                    newPositions.push(8);
                case 19:
                    newPositions.push(3);
                case 20:
                    newPositions.push(24);
                case 21:
                    newPositions.push(19);
                case 22:
                    newPositions.push(14);
                case 23:
                    newPositions.push(9);
                case 24:
                    newPositions.push(4);

            }
        }

        for (i in 0...cursors.members.length){
            cursors.members[i].exists = false;
        }

        for (i in 0...newPositions.length) {
            cursors.members[newPositions[i]].exists = true;
        }
    }
}