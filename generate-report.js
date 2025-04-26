const reporter = require('cucumber-html-reporter');
const fs = require('fs');

try {
  const jsonFile = './reports/cucumber-report.json';
  
  if (!fs.existsSync(jsonFile)) {
    console.error('Arquivo de relatório não encontrado');
    process.exit(1);
  }

  // Verifica se o arquivo não está vazio
  const stats = fs.statSync(jsonFile);
  if (stats.size === 0) {
    console.error('Arquivo de relatório está vazio');
    process.exit(1);
  }

  // Tenta ler o conteúdo para validar o JSON
  const rawData = fs.readFileSync(jsonFile);
  JSON.parse(rawData); // Valida se é JSON válido

  const options = {
    theme: 'bootstrap',
    jsonFile,
    output: './reports/cucumber-report.html',
    reportSuiteAsScenarios: true,
    launchReport: false,
    metadata: {
      "Plataforma": process.platform,
      "Node Version": process.version
    }
  };

  reporter.generate(options);
  console.log('🚀 Relatório HTML gerado com sucesso em reports/cucumber-report.html');
} catch (error) {
  console.error('Erro ao gerar relatório:', error.message);
  process.exit(1);
}