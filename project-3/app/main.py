import os
from flask import Flask, request, jsonify
import pg8000.native

app = Flask(__name__)

DB_HOST = os.environ.get('DB_HOST', 'localhost')
DB_NAME = os.environ.get('DB_NAME', 'appdb')
DB_USER = os.environ.get('DB_USER', 'appuser')
DB_PASS = os.environ.get('DB_PASS', 'password')

def get_conn():
    return pg8000.native.Connection(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        port=5432
    )

@app.route('/')
def home():
    return {'app': 'Abdikani GCP App', 'status': 'running'}

@app.route('/init')
def init():
    try:
        conn = get_conn()
        conn.run('''CREATE TABLE IF NOT EXISTS messages (
            id SERIAL PRIMARY KEY,
            text VARCHAR(500) NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        )''')
        conn.close()
        return {'status': 'table created'}
    except Exception as e:
        return {'error': str(e)}, 500

@app.route('/health')
def health():
    try:
        conn = get_conn()
        conn.run('SELECT 1')
        conn.close()
        return {'status': 'healthy', 'db': 'connected'}
    except Exception as e:
        return {'status': 'unhealthy', 'error': str(e)}, 500

@app.route('/messages', methods=['GET'])
def get_messages():
    conn = get_conn()
    rows = conn.run('SELECT id, text, created_at FROM messages ORDER BY created_at DESC')
    conn.close()
    return [{'id': r[0], 'text': r[1], 'created_at': str(r[2])} for r in rows]

@app.route('/messages', methods=['POST'])
def add_message():
    data = request.get_json()
    conn = get_conn()
    conn.run('INSERT INTO messages (text) VALUES (:text)', text=data['text'])
    conn.close()
    return {'status': 'message saved'}, 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)