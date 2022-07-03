import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'DocumentsModel.dart';
import 'package:flutter/widgets.dart';

String value = "";
int flag = 1;

List<ResultDoc?>? documents; // массив с документами

void main() {
  runApp(MyApp()); // само приложение (объект)
}

class Session {  // Flutter автоматически не сохраняет сессию, поэтому
  // чтобы авторизация не слетала после каждого запроса, нужно
  // создать объект сессии и хранить там куки
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  Map<String, String> headers1 = {'Content-Type': 'application/json'};


  Future<Map> get(String urlText) async { // асинхронно посылаем запрос
    var url = Uri.parse(urlText);
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response); // используется функция updateCookie (объявлена ниже)
    // чтобы сохранялась сессия
    print(response.body);
    return json.decode(response.body);
  }

  Future<int> post(String urlText, dynamic data) async { // post-запрос для авторизации
    var url = Uri.parse(urlText); // адрес, куда посылаем
    http.Response response = await http.post(url, body: data, headers: headers); // кидаем параметры и получаем ответ
    updateCookie(response); // не забываем про куки
    print(response.statusCode);
// если код пришел "200", то все норм. Если нет, то проблема.
    if (response.body.isNotEmpty) {
      print(response.body);
    }
    return response.statusCode;
  }

  Future<String> postMultipart(String urlText, dynamic data) async { // multipart-запрос, в котором отправляается json-файл с
    // параметрами (из Map<String, dynamic> request_data)
    var url = Uri.parse(urlText);

    http.MultipartRequest request = http.MultipartRequest('POST', url); // POST-запрос для url
    request.headers['cookie'] = headers['cookie'] ?? ""; // куки
    request.fields['batch-start'] = '1'; // получить первые 20 документов
    request.fields['batch-size'] = '20';
    // request.fields['file'] = json.encode(data);
    request.files.add(
      http.MultipartFile.fromBytes( // создаем файл и отправляем его
        'file',
        utf8.encode(json.encode(data)),
        filename: "file.json",
        contentType: MediaType(
          'application',
          'json',
          {'charset': 'utf-8'},
        ),
      ),
    );

    print(request.headers); // просто для себя распечатал, так как очень долго ничего не работало и пришлось разбираться
    print(request.fields);
    print(request.files.first.filename);

    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);

    updateCookie(response);
    print(response.statusCode);
    if (response.body.isNotEmpty) {
      print(response.body);
    }
    return response.body;
  }

  void updateCookie(http.Response response) { // сохраняем куки
    String rawCookie = response.headers['set-cookie'] ?? "";
    if (rawCookie != "") {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Документы'),
          backgroundColor: Colors.black54,
        ),
        body: Center(
          child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: MySearchBar(),
                ),
                Container(
                  height: 670,
                  color: Colors.white,
                  child: DocumentsListView(),

                ),
              ]
          ),
        ),
      ),
    );
  }
}

class DocumentsListView extends StatelessWidget {
  const DocumentsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { // собирает данные по запросу (асинхронно)
    return FutureBuilder<List<ResultDoc?>?>(
      future: value == ""? fetchDocuments([]): fetchDocuments([value]),
      builder: (context, snapshot) {
        if (flag == 0) {
          List<ResultDoc?>? data = snapshot.data;
          return documentsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return (Center(
          child: Container( // индикатор загрузки
            height: 128,
            width: 128,
            margin: const EdgeInsets.all(4),
            child: const CircularProgressIndicator(
              strokeWidth: 8.0,
              valueColor : AlwaysStoppedAnimation(Colors.black54),
            ),
          ),
        )
        );
      },
    );
  }

  ListView documentsListView(data) { // список, отображающий документы по образцу
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return OutlinedButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {},
              child: Column(
                  children: [
                    Container( // title
                        height: 50,
                        padding: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Icon(Icons.book, color: Colors.red, size: 26,),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Text(data[index].descriptionHeader.toString(),
                                    style: const TextStyle(color: Colors.black, fontSize: 24),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                        )
                    ),
                    Container( // description body
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(data[index].descriptionBody.toString(),
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 18),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                    ),
                    Container( // keywords
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(data[index].keywords.toString().toLowerCase()
                              .replaceAll('[', '').replaceAll(']', '')
                              .replaceAll(RegExp(r'[0-9, .]+'), ', '),
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        )
                    ),
                    Container( // comments, rating, id
                        height: 40,
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                        color: Colors.white,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Icon(Icons.thumb_up_outlined, color: Colors.grey, size: 22),
                                const Spacer(flex: 1,),
                                Text(data[index].rating?.toString() ?? "0",
                                    style: const TextStyle(color: Colors.grey, fontSize: 20)),
                                const Spacer(flex: 5,),
                                const Icon(Icons.mode_comment_outlined, color: Colors.grey, size: 22,),
                                const Spacer(flex: 1,),
                                Text(data[index].comments?.length.toString() ?? "0",
                                    style: const TextStyle(color: Colors.grey, fontSize: 20)),
                                const Spacer(flex: 50,),
                                Text(data[index].id.toString(),
                                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
                              ],
                            )
                        )
                    ),
                  ]
              )
          );
        }
    );
  }
}


class MySearchBar extends StatefulWidget {
  @override
  _MySearchBarState createState()
  {
    return _MySearchBarState();
  }
}

class _MySearchBarState extends State<MySearchBar> {
  TextEditingController controller =  TextEditingController(text:"");

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: CupertinoSearchTextField(
            controller: controller,
            onChanged: (_value){
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                print("The test text onChanged is: $_value");
            },
            onSubmitted: (_value) async {
              print("Submitted: $_value");
              final documents = await fetchDocuments([_value]); // если ввести слово в поисковую строку
              // и нажать "поиск", данные с серверу придут по новому ключевому слову
              // Теперь есть данные, которые хранятся в documents
              // Далее обновляется listViewBuilder, чтобы он отображал новые данные.
              setState(() {
                flag = 1;
                value = _value.toUpperCase();
                //DocumentsListView();
                runApp(new MyApp());
                // это нужно делать вот здесь. Удачи)
              });
            },
          ),
          trailing: GestureDetector(
            child: const Text(""),
            onTap: (){
              setState(() {
                controller.clear();
              });
            },
          )
      ),
      child: Container(
      ),
    );
  }

}

Future<List<ResultDoc?>?> fetchDocuments([keywords]) async {

  Session object = Session();

  Map auth_data = {
    // данные для авторизации на сервере
    "user": "f636ab96960c6dc8561a497fd7096685",
    "pass": "698d51a19d8a121ce581499d7b701668"
  };

  Map<String, dynamic> request_data = {
    // структура отправляемого запроса
    "keywords": keywords,
    "disciplines": [],
    "themes": [],
    "doctypes": [],
    "users": [],
    "upload-time-cond": 0,
    "upload-time-param": "",
    "authors": [],
    "title": "",
    "publication-date-cond": 0,
    "publication-date-param": "",
    "comments": "",
    "rating-cond": 0,
    "rating-param": 0,
    "sort-order": 1,
    "code": ""
  };

  final request1 = await object.post("https://vega.fcyb.mirea.ru/intellectphp/auth", auth_data); // авторизация
  print(request1);
  final request2 = await object.postMultipart("https://vega.fcyb.mirea.ru/intellectphp/search", request_data);
  // посылается запрос на поиск документов

  final response = documentsFromJson(request2); // это уже распарсенные данные, получили с сервера
  documents = response.resultDocs; // забираем из данных
  flag = 0;
  return documents;
}
