
import 'package:aristadart/arista.dart';

import 'arista_server.dart';

import 'dart:io';
import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_static/shelf_static.dart';
import 'utils/utils.dart';
import 'dart:async';

main() async
{
    
    var dbManager = new MongoDbManager("mongodb://${partialDBHost}/garesco", poolSize: 3);
    
    app.addPlugin(getMapperPlugin(dbManager));
    app.addPlugin(AuthenticationPlugin);
    app.addPlugin(ErrorCatchPlugin);
    
    app.setShelfHandler (createStaticHandler
    (
        staticFolder, 
        defaultDocument: "index.html",
        serveFilesOutsidePath: true
    ));
     
    app.setupConsoleLog();
    
    await app.start(port: port);
    
    MongoDb dbConn = await dbManager.getConnection();  
    
   
    
    User user = await dbConn.findOne
    (
        Col.user,
        User,
        where
            .eq('admin', true)
    );
    
    if (user == null)
    {
        print ("Creando nuevo admin");
        if (tipoBuild == TipoBuild.deploy)
        {
            var newUser = new UserComplete()
                ..nombre = "Arista"
                ..apellido = "Dev"
                ..password = encryptPassword ("TransformandoElMundo!")
                ..email = "info@aristadev.com"
                ..money = 1000000000
                ..admin = true;
            
            await dbConn.insert
            (
                Col.user,
                newUser
            );
        }
        else
        {
            var newUser = new UserComplete()
                ..nombre = "Arista"
                ..apellido = "Dev"
                ..password = encryptPassword("a")
                ..email = "a"
                ..money = 1000000000
                ..admin = true;
            
            await dbConn.insert
            (
                Col.user,
                newUser
            );
        }
    }
    else
    {
        print ("Admin found:");
        print (user.email);
    }
    
    //List users = await dbConn.collection (Col.user).find().toList();
    //users.forEach (print);
}


@app.Interceptor(r'/.*')
handleResponseHeader()
{
    if (app.request.method == "OPTIONS") 
    {
        //overwrite the current response and interrupt the chain.
        app.response = new shelf.Response.ok(null, headers: _specialHeaders());
        app.chain.interrupt();
    } 
    else 
    {
        //process the chain and wrap the response
        app.chain.next(() => app.response.change(headers: _specialHeaders()));
    }
}

@app.Interceptor (r'/private/.+')
authenticationFilter () 
{
    print (app.request.headers);
    if (session["id"] == null)
    {
        app.chain.interrupt 
        (
            statusCode : HttpStatus.UNAUTHORIZED,
            responseValue : {"error": "NOT_AUTHENTICATED"}
        );
    } 
    else 
    {
        app.chain.next ();
    }
}

_specialHeaders() 
{
    var cross = {"Access-Control-Allow-Origin": "*"};
    
    if (tipoBuild <= TipoBuild.jsTesting)
    {
        cross['Cache-Control'] = 'private, no-store, no-cache, must-revalidate, max-age=0';
    }
    
    return cross;
}