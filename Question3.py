import json
import pyodbc
from datetime import datetime
import os

# Hàm thiết lập kết nối đến SQL Server
def create_connect():
    server = 'LAPTOP-TE52KTS'  
    database = 'Question3'
    username = 'sa'
    password = '123456'
    driver = 'ODBC Driver 18 for SQL Server'
   

    conn = pyodbc.connect(f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}')
    return conn

#Hàm tạo bảng employees
def create_employees_table(connect):
     cursor = connect.cursor()

     #Xóa bảng nếu hàm tồn tại
     cursor.execute('DROP TABLE IF EXISTS employees')

     #Tạo bảng
     cursor.execute('''
        CREATE TABLE employees(
       	id int  IDENTITY(1,1) primary key 
	    ,name varchar (50)
	    ,department varchar (50)
	    ,salary int 
	    ,join_date date
        )
                   ''')
     connect.commit()

# Hàm trích xuất dữ liệu từ tệp JSON
def extract_data_from_json(json_file):
    try:
        with open(json_file, 'r', encoding='utf-8') as file:
            data = json.load(file)
        return data.get('employees', None)
    except json.JSONDecodeError as e:
        print(f"Lỗi đọc tệp JSON: {e}")
        return None

# Hàm chuyển đổi và tải dữ liệu vào bảng SQL
def transform_and_load_data(conn, employees_data):
    cursor = conn.cursor()

    for employee in employees_data:
        employee_id = employee['id']
        name = employee['name']
        department = employee['department']
        salary = employee['salary']
        join_date_str = employee['join_date']

        # Chuyển đổi chuỗi ngày vào làm việc sang đối tượng datetime
        join_date = datetime.strptime(join_date_str, '%Y-%m-%d').date()

        # Chèn dữ liệu vào bảng employees
        cursor.execute('''
             INSERT INTO employees (name, department, salary, join_date) 
              VALUES (?, ?, ?, ?)
        ''', ( name, department, salary, join_date))

    conn.commit()


def main():
    json_file = 'employees.json'
      # Kiểm tra sự tồn tại của tệp JSON
    if not os.path.isfile(json_file):
        print(f"Tệp JSON '{json_file}' không tồn tại.")
        return
    
    # Bước 1: Tạo kết nối đến SQL Server
    conn = create_connect()

    # Bước 2: Tạo bảng employees
    create_employees_table(conn)
    print('Đã tạo bảng employees.')

    # Bước 3: Trích xuất dữ liệu từ tệp JSON
    employees_data = extract_data_from_json(json_file)

    # Bước 4: Chuyển đổi và tải dữ liệu vào bảng employees
    transform_and_load_data(conn, employees_data)
    print('Quá trình ETL đã hoàn thành.')

    # Đóng kết nối
    conn.close()

if __name__ == '__main__':
     main()
  



