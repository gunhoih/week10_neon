import streamlit as st
from read_neon_server import get_tables, get_data

st.title("Neon 데이터 조회")

try:
    # Neon PostgreSQL에서 실제 테이블 목록 불러오기
    tables = get_tables()

    if not tables:
        st.info("Neon 데이터베이스에 조회할 테이블이 없습니다.")
    else:
        table = st.selectbox("테이블 선택", tables)
        df = get_data(table)

        # 검색어를 모든 열에서 찾기 (대소문자 구분 없음)
        keyword = st.text_input("검색어 입력")
        if keyword:
            df = df[
                df.astype(str).apply(
                    lambda col: col.str.contains(
                        keyword, case=False, na=False, regex=False
                    )
                ).any(axis=1)
            ]

        st.write(f"검색 결과: {len(df)}건")
        st.dataframe(df, width="stretch", hide_index=True)

        # 현재 화면에 표시된 검색 결과만 CSV로 저장
        st.download_button(
            label="CSV 다운로드",
            data=df.to_csv(index=False).encode("utf-8-sig"),
            file_name=f"{table}.csv",
            mime="text/csv",
        )

except Exception as e:
    st.error(f"오류 발생: {e}")
