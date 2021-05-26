'use strict';

const {
    Contract
} = require('fabric-contract-api');

class JugadoresContract extends Contract {

    async queryJugador(ctx, dni) {

        let jugadorStatus = await ctx.stub.getState(dni);

        if (!jugadorStatus || jugadorStatus.toString().length <= 0) {
            throw new Error('No existe ningun jugador dado de alta con este DNI: ' + {
                dni
            });
        }

        let jugador = JSON.parse(jugadorStatus.toString());
        return JSON.stringify(jugador);

    }

    async addJugador(ctx, dni, nombre, apellidos, edad, equipo, precio) {

        let jugador = {
            nombre: nombre,
            apellidos: apellidos,
            edad: edad,
            equipo: equipo,
            precio: precio
        };

        await ctx.stub.putState(dni, Buffer.from(JSON.stringify(jugador)));

        console.log('El jugador ha sido registrado correctamente');

    }

    async deleteMarks(ctx, studentId) {

        await ctx.stub.deleteState(studentId);
        console.log('Student Marks deleted from the ledger Succesfully..');

    }


}

module.exports = JugadoresContract;