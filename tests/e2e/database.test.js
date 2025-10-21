const request = require('supertest');
const app = require('../../src/app');
const db = require('../../src/database/db');

// SEM mock - usa banco real
describe('Testes E2E com Banco Real', () => {
  beforeAll(async () => {
    // Configurar banco de teste
    await db.query('CREATE TABLE IF NOT EXISTS cursos_test AS SELECT * FROM cursos WHERE 1=0');
  });

  afterAll(async () => {
    // Limpar dados de teste
    await db.query('DROP TABLE IF EXISTS cursos_test');
    await db.end();
  });

  beforeEach(async () => {
    // Limpar dados antes de cada teste
    await db.query('DELETE FROM cursos_test');
  });

  it('Deve criar curso no banco real', async () => {
    const response = await request(app)
      .post('/cursos')
      .send({ nome: 'Curso Real', descricao: 'Teste real' });
    
    expect(response.statusCode).toBe(201);
    
    // Verificar se foi salvo no banco
    const result = await db.query('SELECT * FROM cursos WHERE nome = $1', ['Curso Real']);
    expect(result.rows).toHaveLength(1);
  });
});