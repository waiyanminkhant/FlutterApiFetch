import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProduct() async{
  var url =Uri.parse('https://fakestoreapi.com/products');
  final response  = await http.get(url);

  if(response.statusCode == 200){

    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
    //return Product.fromJson(jsonDecode(response.body));

  }else{
    throw Exception("Failed to load Product");
  }
}

class Product {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    category: json["category"],
    image: json["image"],
    rating: Rating.fromJson(json["rating"]),
  );
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    rate: json["rate"]?.toDouble(),
    count: json["count"],
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Product> futureProduct;

  @override
  void initState(){
    super.initState();
    //futureProduct = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Testing API"),
        leading: Icon(Icons.get_app),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: FutureBuilder<List<Product>>(
          future: fetchProduct(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index) => Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Image.network(snapshot.data![index].image,),
                          title: Text(snapshot.data![index].title),
                            subtitle: Text("Price : "+snapshot.data![index].price.toString()),
                          )
                        ],
                      ),
                    )
                    ,

                  ));

            }
            else{
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            }
          },
        ),
      ),
    ));
  }

}
