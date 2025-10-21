-- Criação das tabelas
CREATE TABLE IF NOT EXISTS cursos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    curso_id INTEGER REFERENCES cursos(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dados iniciais
INSERT INTO cursos (nome, descricao) VALUES 
('Desenvolvimento Web', 'Curso completo de desenvolvimento web'),
('DevOps', 'Curso de práticas DevOps e automação');

INSERT INTO alunos (nome, email, curso_id) VALUES 
('João Silva', 'joao@email.com', 1),
('Maria Santos', 'maria@email.com', 2);