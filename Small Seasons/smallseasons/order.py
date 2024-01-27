import json

def sort_json_by_date(filename):
    with open(filename, 'r') as file:
        data = json.load(file)

    data['sekki'].sort(key=lambda x: x['startDate'])

    with open(filename, 'w') as file:
        json.dump(data, file, indent=4)

sort_json_by_date('content.json')
