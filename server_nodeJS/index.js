var PORT = process.env.PORT || 5000;
var express = require('express');
var app = express();
var http = require('http');
var server = http.Server(app);

var led = 0;


server.listen(PORT, function () {
    console.log('listening on *:' + PORT);
}
);

var io = require('socket.io')(server);

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});


app.get('/cars', function (req, res) {
    res.sendFile(__dirname + '/cars.html');
});

app.get('/carsMock', function (req, res) {

    res.sendFile(__dirname + '/carsMock.html');
});

app.get('/ttb', function (req, res) {


    res.sendFile(__dirname + '/ttb.html');

    //var messageObject = { stationID: bufferStationID };
    //io.emit('gettimetable', messageObject);

});

app.get('/ttb/:stationid', function (req, res) {
    const { stationid } = req.params

    if ((stationid == null) || (stationid == undefined) || (stationid == 'undefined') || (stationid == '')) {
        return;
    }
    //bufferStationID = stationid;
    var messageObject = { stationID: stationid };
    io.emit('gettimetable', messageObject);

    res.redirect('/ttb?id=' + stationid);

    //io.emit('gettimetable', messageObject);

});


app.get('/stop/:carId', function (req, res) {
    const { carId } = req.params;

    if ((carId == null) || (carId == undefined) || (carId == 'undefined') || (carId == '')) {
        return;
    }


    console.log(carId);

    var messageOBJ = { carID: carId };
    io.emit('stop', messageOBJ);

    res.sendFile(__dirname + '/cars.html');

});

app.get('/continue/:carId', function (req, res) {
    const { carId } = req.params;
    if ((carId == null) || (carId == undefined) || (carId == 'undefined') || (carId == '')) {
        return;
    }

    console.log(carId);

    var messageOBJ = { carID: carId };
    io.emit('continue', messageOBJ);

    res.sendFile(__dirname + '/cars.html');

});

app.get('/arrived/', function (req, res) {
    var carId = "";
    var stationId = "";
    for (const key in req.query) {
        console.log(key, req.query[key])
        if (key == "carId") {
            carId = req.query[key]
        }

        if (key == "stationId") {
            stationId = req.query[key]
        }
    }

    if ((carId == null) || (carId == undefined) || (carId == 'undefined') || (carId == '')) {
        carId = "";
    }
    if ((stationId == null) || (stationId == undefined) || (stationId == 'undefined') || (stationId == '')) {
        res.write("0"); //write a response to the client
        res.end(); //end the response
        return;
    }
    //console.log(carId);
    var messageOBJ = { carID: carId, stationID: stationId };
    io.emit('arrived', messageOBJ);

    res.write("1"); //write a response to the client
    res.end(); //end the response

});

app.get('/registerControl/', function (req, res) {
    var shipID = "";
    for (const key in req.query) {
        console.log(key, req.query[key])
        if (key == "name") {
            shipID = req.query[key]
        }
    }

    var messageOBJ = { name: shipID };
    io.emit('registerControl', messageOBJ);

    res.write("1"); //write a response to the client
    res.end(); //end the response
});


app.get('/restartsim', function (req, res) {
    var messageObject = { servercommand: 'restart' };
    io.emit('restartsim', messageObject);

    res.sendFile(__dirname + '/cars.html');
});



app.get('/hello', function (req, res) {
    res.send('Hello World!!!')
});

app.get('/port', function (req, res) {
    res.send('PORT:' + PORT)
});


io.on('connect',
    function (socket) {
        console.log('a user connected');


        socket.on('command', function (msg) {
            //console.log('message: ' + msg);

            var strJson = JSON.stringify(msg, null, 4)
            //console.log(strJson);
            //io.emit('cars', msg);

            try {
                const commandDic = JSON.parse(strJson.trim());

                //----
                // Cars
                //----
                readCarsCommand(commandDic);
                //----

                readTimeTableCommand(commandDic);
                //----
                // Emergency
                //----
                //readEmergency(commandDic);
                //----


                //----
                // Noti Car arrive
                //----
                //notiCarArrive(commandDic);
                //----


            } catch (err) {
                console.log("error");
                console.error(err);
            }
        });


        socket.on('gettimetable', function (msg) {
            //io.emit('gettimetable', messageObject);
        });


        socket.on('stop', function (msg) {
            io.emit('stop', msg);
        });


        socket.on('stopAll', function (msg) {
            console.log('stopAll');
            io.emit('stopAll', msg);
        });


        socket.on('continue', function (msg) {
            io.emit('continue', msg);
        });

        socket.on('arrived', function (msg) {
            console.log('arrived');
            console.log(msg);
            io.emit('arrived', msg);
        });


        socket.on('arduino', function (data) {
            console.log(data);
            io.emit('arduino', data);
        });

        socket.on('registerCar', function (data) {
            // console.log('registerCar');
            // console.log(data);
            io.emit('registerCar', data);
        });

        socket.on('registerControl', function (data) {
            // console.log('registerCar');
            // console.log(data);
            io.emit('registerControl', data);
        });


        socket.on('checkStatus', function (data) {
            console.log('checkStatus');
            console.log(data);
            io.emit('checkStatus', data);
        });

        /// test loop echo data
        setTimeout(function run() {
            io.emit('checkStatus', { stop: 'all' });


            setTimeout(run, 5000);
        }, 5000);
        ///////

    }
);




function readCarsCommand(commandDic) {
    var carsListData = commandDic["cars"];
    if (carsListData != null) {
        //console.log(cars);
        var carsObject = { cars: carsListData };
        io.emit('cars', carsObject);
    }
}


function readTimeTableCommand(commandDic) {
    var messageData = commandDic["timetable"];
    if (messageData != null) {
        var sid = messageData["stationId"];

        var room = "timetable" + sid

        io.emit(room, messageData);
    }
}


function readEmergency(commandDic) {
    var emergencyData = commandDic["emergency"];
    if (emergencyData.length > 0) {
        //console.log(cars);
        var emObject = { emergency: emergencyData };
        io.emit('emergency', emObject);
    }
}


function notiCarArrive(commandDic) {
    var messageData = commandDic["arrive"];
    if (messageData.length > 0) {
        //console.log(cars);
        var messageObject = { arrive: messageData };
        io.emit('arrive', messageObject);
    }
}





function trainSampleData() {
    return {
        id: "T01",
        name: "Train01",
        from: "D07",
        strDepartTime: "28-11-2019 15:36:10",
        to: "B01-A",
        strArriveTime: "28-11-2019 15:46:10",
        startStation: "สถานีต้นทาง",
        endStation: "สถานีปลายทาง",
        status: 1,
        crowdStatus: 0,
        timeTableID: "tb01",
        dewellTime: "45",
        speed: "1",
        direction: 0,
        timeStamp: Math.floor(Date.now() / 1000)
    };
}

function gatCarsPosition() {

    return {

        cars: [
            {
                id: 1,          //Car ID
                name: "001",    //car name
                from: "D01",    //เดินทางจาก สถานี
                to: "B02-A",    //เดินทางไปสถานี
                position: 0,    // 0 = อยู่ที่สถานีต้นทาง, 1 = อยู่ระหว่างทาง, 2 = ถึงปลายทางแล้ว
                status: 1,      // 0 = ไม่ทราบสถาณะ, 1 = จอดรับผู้โดยสาร, 2 = รอออกรถ, 3 = กำลังเดินทาง, 4 = ถึงที่หมาย, 5 = หยุดรถฉุกเฉิน, 6 = รถหยุดวิ่ง / ไม่ทำงาน / จบการทำงาน , 7 = อยู่ระหว่างประมวลผล
                direction: 0,   // 0 = ขาไป, 1 = ขากลับ
                line: "pink"    // pink, blue
            },
            {
                id: 2,
                name: "002",
                from: "B02-A",
                to: "B03-A",
                position: 1,
                status: 1,
                direction: 0,
                line: "pink"
            },
            {
                id: 3,
                name: "003",
                from: "B04-A",
                to: "B05-A",
                position: 2,
                status: 1,
                direction: 0,
                line: "pink"
            },
            {
                id: 4,
                name: "004",
                from: "B04-B",
                to: "B03-B",
                position: 2,
                status: 1,
                direction: 1,
                line: "pink"
            }
        ]

    };


    function getTimetableWith(stationId) {

        var messageObject = { stationID: stationId };
        io.emit('gettimetable', messageObject);
    };





    function sentArrivedWith(carNameValue, stationIdValue) {
        var message = { carID: carNameValue, stationID: stationIdValue };

        io.emit('arrived', message);
    }

}

