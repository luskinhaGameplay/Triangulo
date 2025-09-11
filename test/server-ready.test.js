import request from 'supertest';
import server from '../src/server.js';

describe('Test server readiness', () => {
    it('Should get server ready', async ()=>{
       const reponse = await request(server)
         .get('/ready');
       expect(reponse.status).toEqual(200);
       expect(reponse.body.message).toEqual('SERVER READY');
    }) ;
});