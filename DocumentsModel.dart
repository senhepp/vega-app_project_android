/* Тут объявлено все, что нужно для класса документ, в который вставляются данные, полученные через API.

То есть мы отправляем запрос к API и получаем JSON, далее нам этот JSON (по сути текст).
Чтобы из этого текста нам получить объекты и работать с ними (то есть распарсить текст),
мы нам как раз и нужны эти классы. (в этом файле обявлен только прототип класса, а все эти действия делаются в файле main.dart)

То есть мы получаем вот такое:
{"total-count":"5","request-id":"3212","batch-start":"1","batch-size":"5","result-docs":
[{"id":"807","doc-type":"1","title":"UML. Основы","description-header":"Фаулер М.","description-body":"UML. Основы. — 3-е изд. — СПб.: Символ-Плюс, 2004. — 181 c.: ил.","code":"0403","url":null,"req-rel":"0.0128844",
"keywords":[["ДИАГРАММА","0.0237224"],["КЛАСС","0.0217407"],["ЯЗЫК","0.0152948"],
["UML","0.0128844"],["ВАРИАНТ","0.0120246"],["ИСПОЛЬЗОВАНИЕ","0.0119195"],["ЗАКАЗ","0.00892595"],["ОБЪЕКТ","0.00852809"],["АССОЦИАЦИЯ","0.0066228"],["КНИГА","0.00658867"],
["МЕТОД","0.00592722"],["ДЕЯТЕЛЬНОСТЬ","0.00566588"],["КЛИЕНТ","0.00522331"],["ПРОЕКТ","0.0050316"],
["РАЗРАБОТЧИК","0.00468331"],["СОСТОЯНИЕ","0.00429486"],["ПАКЕТ","0.0042916"],["ПРОЦЕСС","0.00416018"],
["ИНТЕРФЕЙС","0.00414831"],["МОДЕЛЬ","0.00372844"]],"comments"........

А после парсинга у нас есть массив документов List<ResultDoc>? documents,
в котороим хранится каждый документ. И мы можем обратиться к каждому его атрибуту:
id, docType, title, descriptionHeader, descriptionBody, code, url, reqRel, keywords, comments, rating

То есть чтобы получить название первого документа, пишем во так documents[0].title


Пока именно этот файл менять не надо, тут вроде есть все, что вам нужно.
 */

import 'dart:convert';

Documents documentsFromJson(String str) => Documents.fromJson(json.decode(str));

String documentsToJson(Documents data) => json.encode(data.toJson());

class Documents {
  Documents({
    this.totalCount,
    this.requestId,
    this.batchStart,
    this.batchSize,
    this.resultDocs,
    this.resultKeywords,
  });

  String? totalCount;
  String? requestId;
  String? batchStart;
  String? batchSize;
  List<ResultDoc>? resultDocs;
  List<List<String>>? resultKeywords;

  factory Documents.fromJson(Map<String, dynamic> json) => Documents(
    totalCount: json["total-count"] == null ? null : json["total-count"],
    requestId: json["request-id"] == null ? null : json["request-id"],
    batchStart: json["batch-start"] == null ? null : json["batch-start"],
    batchSize: json["batch-size"] == null ? null : json["batch-size"],
    resultDocs: json["result-docs"] == null
        ? null
        : List<ResultDoc>.from(
        json["result-docs"].map((x) => ResultDoc.fromJson(x))),
    resultKeywords: json["result-keywords"] == null
        ? null
        : List<List<String>>.from(json["result-keywords"]
        .map((x) => List<String>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "total-count": totalCount == null ? null : totalCount,
    "request-id": requestId == null ? null : requestId,
    "batch-start": batchStart == null ? null : batchStart,
    "batch-size": batchSize == null ? null : batchSize,
    "result-docs": resultDocs == null
        ? null
        : List<dynamic>.from(resultDocs!.map((x) => x.toJson())),
    "result-keywords": resultKeywords == null
        ? null
        : List<dynamic>.from(resultKeywords!
        .map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}

class ResultDoc {
  ResultDoc({
    this.id,
    this.docType,
    this.title,
    this.descriptionHeader,
    this.descriptionBody,
    this.code,
    this.url,
    this.reqRel,
    this.keywords,
    this.comments,
    this.rating,
  });

  String? id;
  String? docType;
  String? title;
  String? descriptionHeader;
  String? descriptionBody;
  String? code;
  String? url;
  String? reqRel;
  List<List<String>>? keywords;
  List<Comment>? comments;
  String? rating;

  factory ResultDoc.fromJson(Map<String, dynamic> json) => ResultDoc(
    id: json["id"] == null ? null : json["id"],
    docType: json["doc-type"] == null ? null : json["doc-type"],
    title: json["title"] == null ? null : json["title"],
    descriptionHeader: json["description-header"] == null
        ? null
        : json["description-header"],
    descriptionBody:
    json["description-body"] == null ? null : json["description-body"],
    code: json["code"] == null ? null : json["code"],
    url: json["url"] == null ? null : json["url"],
    reqRel: json["req-rel"] == null ? null : json["req-rel"],
    keywords: json["keywords"] == null
        ? null
        : List<List<String>>.from(json["keywords"]
        .map((x) => List<String>.from(x.map((x) => x)))),
    comments: json["comments"] == null
        ? null
        : List<Comment>.from(
        json["comments"].map((x) => Comment.fromJson(x))),
    rating: json["rating"] == null ? null : json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "doc-type": docType == null ? null : docType,
    "title": title == null ? null : title,
    "description-header":
    descriptionHeader == null ? null : descriptionHeader,
    "description-body": descriptionBody == null ? null : descriptionBody,
    "code": code == null ? null : code,
    "url": url == null ? null : url,
    "req-rel": reqRel == null ? null : reqRel,
    "keywords": keywords == null
        ? null
        : List<dynamic>.from(
        keywords!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "comments": comments == null
        ? null
        : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "rating": rating == null ? null : rating,
  };
}

class Comment {
  Comment({
    this.userid,
    this.username,
    this.comment,
  });

  String? userid;
  String? username;
  String? comment;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    userid: json["userid"] == null ? null : json["userid"],
    username: json["username"] == null ? null : json["username"],
    comment: json["comment"] == null ? null : json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid == null ? null : userid,
    "username": username == null ? null : username,
    "comment": comment == null ? null : comment,
  };
}