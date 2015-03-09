library aristadart.tests;

import 'package:unittest/unittest.dart';

import 'package:aristadart/arista.dart';
import 'package:redstone/server.dart' as app;
import 'package:redstone/mocks.dart';
import 'arista_server.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/plugin.dart';

part 'tests/test_user_services.dart';
part 'tests/test_maquina_services.dart';


main() 
{
    //SETUP
    var dbManager = new MongoDbManager("mongodb://${partialDBHost}/tests", poolSize: 3);             
    app.addPlugin(getMapperPlugin(dbManager));
    app.addPlugin(AuthenticationPlugin);
    app.addPlugin(ErrorCatchPlugin);
    app.setUp([#aristadart.server]);
    
    //TESTS
    userServicesTests();
    
    //TEARDOWN
    app.tearDown();
}