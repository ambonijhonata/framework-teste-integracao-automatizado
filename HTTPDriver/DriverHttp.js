
class DriverHTTP {    

    constructor(baseUrl = 'http://localhost:8080') {
        this.baseUrl = baseUrl;
    }

    setToken(token) {
        this.token = token;
    }

    #buildHeaders() {
        const headers = {
            'Content-Type': 'application/json'
        };
        
        if (this.token) {
            headers['Authorization'] = `Bearer ${this.token}`;
        }

        return headers;
    }

    async POST(endpoint, body) {
        const url = `${this.baseUrl}/${endpoint}`;

        const options = {
            method: 'POST',
            headers: this.#buildHeaders(), 
            body: JSON.stringify(body)
        };

        try {
            const response = await fetch(url, options);
            const status = response.status;
            
            if (!response.ok) {
                const errorData = await response.json().catch(() => null);
                throw new Error(
                    `Erro na requisição: ${url}\n` +
                    `Status: ${response.status}\n` +
                    `Mensagem: ${errorData?.message || 'Sem mensagem de erro'}`
                );
            }
    
            const responseData = await response.json();
            return {status, data: responseData};
            
        } catch (error) {            
            throw error;
        }
    }

    async GET(endpoint) {
        let url = `${this.baseUrl}/${endpoint}`;
        
        const options = {
            method: 'GET',
            headers: this.#buildHeaders()
        };

        try {
            const response = await fetch(url, options);
            const status = response.status;

            if (!response.ok) {                
                const errorData = await response.json().catch(() => null);
                throw new Error(
                    `Erro na requisição: ${url}\n` +
                    `Status: ${response.status}\n` +
                    `Mensagem: ${errorData?.message || 'Sem mensagem de erro'}`
                );
            }
            
            if (status === 204) {
                return null;
            }

            const responseData = await response.json();
            return {status, data: responseData};            
        } catch (error) {
            console.error('Erro na requisição GET:', error);
            throw error;
        }
    }

    async DELETE(endpoint) {
        const url = `${this.baseUrl}/${endpoint}`;

        const options = {
            method: 'DELETE',
            headers: this.#buildHeaders()
        };

        try {
            const response = await fetch(url, options);
            const status = response.status;

            if (!response.ok) {
                const errorData = await response.json().catch(() => null);
                throw new Error(
                    `Erro na requisição: ${url}\n` +
                    `Status: ${response.status}\n` +
                    `Mensagem: ${errorData?.message || 'Sem mensagem de erro'}`
                );
            }
            
            if (status === 204) {
                return { status, data: null };
            }

            const responseData = await response.json();
            return { status, data: responseData };
        } catch (error) {
            console.error('Erro na requisição DELETE:', error);
            throw error;
        }
    }
    
        async PUT(endpoint, body) {
        const url = `${this.baseUrl}/${endpoint}`;

        const options = {
            method: 'PUT',
            headers: this.#buildHeaders(),
            body: JSON.stringify(body)
        };

        try {
            const response = await fetch(url, options);
            const status = response.status;

            if (!response.ok) {
                const errorData = await response.json().catch(() => null);
                throw new Error(
                    `Erro na requisição: ${url}\n` +
                    `Status: ${response.status}\n` +
                    `Mensagem: ${errorData?.message || 'Sem mensagem de erro'}`
                );
            }

            if (status === 204) {
                return { status, data: null };
            }

            const responseData = await response.json();
            return { status, data: responseData };
        } catch (error) {
            console.error('Erro na requisição PUT:', error);
            throw error;
        }
    }

}

module.exports = { DriverHTTP };