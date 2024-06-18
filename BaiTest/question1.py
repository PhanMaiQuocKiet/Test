import json
from collections import Counter

def main():
    #input():Nhập dữ liệu từ bên ngoài
    print("Nhập dữ liệu : ")
    input_text:str = input()

   
    
    # Đếm số lần xuất hiện của từng từ và ghi vào các tệp JSON
    def_word_cnt(input_text, 1, 100)

    

#hàm def_word_cnt 
def def_word_cnt(input_text,file_number, max_number):
    #Split(): Tách chuỗi 
    #("Xin Chào Thế Giới") => ["Xin","Chào","Thế","Giới"] => "xin": 1,"Chào":1,"Thế":1,"Giới":1
    worldSplit = input_text.split()

    #đếm phần tử xuất hiện có trong mảng sau kho tách chuỗi
    #https://t3h.com.vn/tin-tuc/bo-dem-trong-python
    word_counts  = Counter(worldSplit)
    
     # In ra số lần xuất hiện của mỗi từ dưới dạng json 
    generate_json_files(file_number, max_number,word_counts)
        

def generate_json_files(file_number, max_number,word_counts):
    #nếu số file (1) > max_number(100) thì return
    if file_number > max_number:
        return
    filename = f"result_{file_number}.json"
    data = {"word_counts": word_counts}  # Dữ liệu  để ghi vào tệp JSON
    with open(filename, 'w', encoding='utf-8') as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)

    # Đệ quy để ghi các tệp JSON tiếp theob
    generate_json_files(file_number + 1, max_number, word_counts)




if __name__ == '__main__':
    main()