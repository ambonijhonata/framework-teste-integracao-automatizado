
class DriverHTTP {

    constructor(baseUrl = 'http://localhost:8080') {
        this.baseUrl = baseUrl;
    }

    async POST(endpoint, body) {
        const url = `${this.baseUrl}/${endpoint}`;

        const options = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body)
        };

        try {
            const response = await fetch(url, options);
            
            if (!response.ok) {
                console.log("Deu erro na requisicao")
                console.log(response)
                const errorData = await response.json().catch(() => null);
                throw new Error(
                    `Erro na requisição: ${url}\n` +
                    `Status: ${response.status}\n` +
                    `Mensagem: ${errorData?.message || 'Sem mensagem de erro'}`
                );
            }
    
            const responseData = await response.json();
            return responseData;
            
        } catch (error) {
            console.error('Erro na requisição POST:', error);
            throw error;
        }
    }

}

module.exports = { DriverHTTP };