import os
from pathlib import Path

import pandas as pd
import psycopg
from psycopg import sql
from dotenv import load_dotenv

# 로컬에서는 같은 폴더의 .env, 배포 환경에서는 Secrets 환경변수를 사용
load_dotenv(Path(__file__).resolve().parent / ".env")


def connect_db():
    # Neon Connect 화면에서 복사한 PostgreSQL 연결 주소
    database_url = os.getenv("DATABASE_URL", "").strip()
    if not database_url:
        raise ValueError("DATABASE_URL이 없습니다. .env 또는 Streamlit Secrets를 확인하세요.")
    return psycopg.connect(database_url, connect_timeout=10)


def get_tables():
    # Neon의 public 스키마에 있는 테이블 목록 조회
    with connect_db() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT table_name
                FROM information_schema.tables
                WHERE table_schema = 'public'
                  AND table_type = 'BASE TABLE'
                ORDER BY table_name
            """)
            return [row[0] for row in cursor.fetchall()]


def get_data(table):
    # 선택한 테이블 데이터를 Pandas DataFrame으로 반환
    with connect_db() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT 1
                FROM information_schema.tables
                WHERE table_schema = 'public'
                  AND table_type = 'BASE TABLE'
                  AND table_name = %s
            """, (table,))
            if cursor.fetchone() is None:
                raise ValueError(f"'{table}' 테이블이 없습니다.")

            # 테이블명은 안전하게 인용하여 SQL 삽입을 방지
            query = sql.SQL("SELECT * FROM {}").format(sql.Identifier("public", table))
            cursor.execute(query)
            columns = [col.name for col in cursor.description]
            return pd.DataFrame(cursor.fetchall(), columns=columns)
