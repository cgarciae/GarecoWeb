library aristadart.client;

//Dependencies
import 'package:aristadart/arista.dart';
import 'dart:async';
import 'package:redstone_mapper/mapper.dart';
import 'package:angular/angular.dart';
import 'dart:html' as dom;
import "package:googleapis_auth/auth_browser.dart" as auth;
import 'package:googleapis/oauth2/v2.dart' as oauth;

//Components
part 'components/main_controller.dart';
part 'components/evento/evento.dart';
part 'components/widgets/loader/loader.dart';
part 'components/vista/vista.dart';
part 'components/login/login.dart';
part 'components/login/nuevo_usuario.dart';
part 'components/home/home.dart';
part 'components/admin/admin.dart';
part 'components/admin/model.dart';
part 'components/admin/target.dart';
part 'routing/router.dart';

//Services
part 'services/client_file_services.dart';
part 'services/client_user_services.dart';
part 'services/client_maquina_services.dart';
part 'services/core/client_service.dart';
part 'services/core/requester.dart';

/////////////////
//PROPERTIES
/////////////////
dom.Storage get storage => dom.window.localStorage;
bool get loggedIn => notNullOrEmpty(userId);
bool get loggedAdmin => storage['admin'] == true.toString();
set loggedAdmin (bool value) => storage['admin'] = value.toString();
String get userId => storage['userId'];
set userId (String id) => storage['userId'] = id;

/////////////////
//FUNCTIONS
/////////////////

logout ()
{
    storage.remove('userId');
    storage.remove('admin');
}

String appendRequestParams (String path, Map<String,String> params)
{
    path += '?';
    for (String key in params.keys)
    {
        path += '${key}=${Uri.encodeQueryComponent(params[key])}&';
    }
    
    return path;
}



Function doIfSuccess ([dynamic f (dynamic)])
{
    return (dynamic resp)
    {
        if (resp.success)
        {
            if (f != null)
                return f (resp);
        }
        else
        {
            print (resp.error);
            return resp;
        }
    };
}

ifRespSuccess (Resp resp, Function f)
{
    if (resp.success)
    {
        if (f != null)
            return f (resp);
    }
    else
    {
        print (resp.error);
        return resp;
    }
}


dom.FormElement getFormElement (dom.MouseEvent event)
    => (event.target as dom.ButtonElement).parent as dom.FormElement;




