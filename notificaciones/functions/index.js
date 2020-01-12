const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

var msgData;
var msgDataBefore;

exports.newSubscriberNotification = functions.firestore
    .document('wheels/{wheelsId}')
    .onUpdate((snap, context) => {
        msgData = snap.after.data();
        msgDataBefore = snap.before.data();
        var este;
        var token;
        var payload;
        if(msgData.estado==msgDataBefore.estado && msgData.pasajeros.length==msgDataBefore.pasajeros.length){
            console.log("no ha habido cambio en el estado");
        }
        else{
            if(msgData.estado!=msgDataBefore.estado){
                for(var i =0; i< msgDataBefore.pasajeros.length; i++){
                    este =msgDataBefore.pasajeros[i].idPasajero;
                    este.get().then((snap)=>{
                         token = snap.data().token;
                         payload = {
                            "notification": {
                                "title": "El estado de su wheels ha sido cambiado ",
                                "body": "Su wheels a sido " + msgData.estado,
                                "sound": "default"
                            },
                            "data": {
                                "sendername": "hola",
                                "message": "Su wheels a sido " + msgData.estado
                            }
                        }
                        admin.messaging().sendToDevice(token, payload).then((response) => {
                            console.log('Pushed them all');
                        }).catch((err) => {
                            console.log(err);
                    });
                    })
                }
            }
            if(msgData.pasajeros.length>msgDataBefore.pasajeros.length){
                este = msgData.idConductor;
                este.get().then((snap)=>{
                    token = snap.data().token;
                    payload = {
                       "notification": {
                           "title": "Alguien reservó un cupo en tu wheels ",
                           "body":  "Ahora tienes  " + msgData.cupos +" disponibles",
                           "sound": "default"
                       },
                       "data": {
                           "sendername": "hola",
                           "message": "Ahora tienes  " + msgData.cupos +" disponibles"
                       }
                   }
                   admin.messaging().sendToDevice(token, payload).then((response) => {
                       console.log('Pushed them all');
                   }).catch((err) => {
                       console.log(err);
               });
               });
            }
            if(msgData.pasajeros.length<msgDataBefore.pasajeros.length){
                este = msgData.idConductor;
                este.get().then((snap)=>{
                    token = snap.data().token;
                    payload = {
                       "notification": {
                           "title": "Alguien canceló un cupo en tu wheels ",
                           "body":  "Ahora tienes  " + msgData.cupos +" disponibles",
                           "sound": "default"
                       },
                       "data": {
                           "sendername": "hola",
                           "message": "Ahora tienes  " + msgData.cupos +" disponibles"
                       }
                   }
                   admin.messaging().sendToDevice(token, payload).then((response) => {
                       console.log('Pushed them all');
                   }).catch((err) => {
                       console.log(err);
               });
               });
            }
            
        }
        

    });