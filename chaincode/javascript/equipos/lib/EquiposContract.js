'use strict';

const {
    Contract
} = require('fabric-contract-api');

class EquiposContract extends Contract {

    async queryCompra(ctx, id) {

        let compraStatus = await ctx.stub.getState(id);

        if (!compraStatus || compraStatus.toString().length <= 0) {
            throw new Error('No existe ninguna compra dada de alta con este id');
        }

        let compra = JSON.parse(compraStatus.toString());
        return JSON.stringify(compra);

    }

    async comprarJugador(ctx, id, dni, equipo, precio) {

        let compra = {
            jugador: dni,
            equipo: equipo,
            precio: precio
        };

        await ctx.stub.putState(id, Buffer.from(JSON.stringify(compra)));

        console.log('La compra del jugador ha sido registrada correctamente');

    }

}

module.exports = EquiposContract;