import pandas as pd

excel_file = pd.ExcelFile("./address2.xlsx")
sheet_names = excel_file.sheet_names

village_names = []
gram_panchayat_names = []
taluk_names = []
sheet_names_for_json = []
total = 0

for sheet_name in sheet_names:
    sheet = pd.read_excel("./address2.xlsx", sheet_name=sheet_name)

    village_cols = sheet.columns[1::5]
    village_names_list = sheet[village_cols].values.tolist()
    village_names_list = [item for sublist in village_names_list for item in sublist]
    total += len(village_names)

    gram_panchayat_cols = sheet.columns[2::5]
    gram_panchayat_names_list = sheet[gram_panchayat_cols].values.tolist()
    gram_panchayat_names_list = [item for sublist in gram_panchayat_names_list for item in sublist]

    taluk_cols = sheet.columns[3::5]
    taluk_names_list = sheet[taluk_cols].values.tolist()
    taluk_names_list = [item for sublist in taluk_names_list for item in sublist]

    gram_panchayat_names_list.append(taluk_names_list[0])
    gram_panchayat_names.extend(gram_panchayat_names_list)

    village_names_list.append(taluk_names_list[0])
    village_names.extend(village_names_list)

    taluk_names_list.append(taluk_names_list[0])
    taluk_names.extend(taluk_names_list)

    print("=====================================")
    temp_list = []
    
    for i in range(len(taluk_names_list)):
        temp_list.append(sheet_name)
        
    print(temp_list.__len__() == taluk_names_list.__len__() == village_names_list.__len__() == gram_panchayat_names_list.__len__())
    sheet_names_for_json.extend(temp_list)

d = {"Village Name": village_names, "Gram Panchayat": gram_panchayat_names, "TALUK": taluk_names,"district":sheet_names_for_json, "state": "Karnakata"}
df = pd.DataFrame(d)
df.dropna(inplace=True)
# df.drop_duplicates(inplace=True)
df.to_csv("./address.csv", index=False)
df.to_json("./address.json", orient="records")
