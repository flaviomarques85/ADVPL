import axios from 'axios';

class Api{

    static async getCustomer(cod){
        const response = await axios.get('http://localhost:8089/rest/CLIENTES?CGCCLI=',{cod});
        console.log('response: ', response);
        
    }
}

Api.getCustomer('07139853000158');