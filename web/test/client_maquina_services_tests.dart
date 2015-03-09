part of aristadart.client.tests;

runClientMaquinaServicesTest ()
{
    group ("Maquina:", ()
    {
        ClientMaquinaServices services;
        
        ClientUserServices userServices;
        
        setUp(()
        {
            var user = new User()
                ..nombre = "Juan"
                ..apellido = "Perez"
                ..email = "juanperez@gmail.com";
            
            var tempServices = new ClientUserServices(user);
            
            return tempServices.NewOrLogin().then((User resp)
            {
                userId = resp.id;
                userServices = new ClientUserServices(resp);
            });
        });
        
        tearDown(()
        {
            return userServices.DeleteGeneric().then((_)
            {
                logout();
            });
        });
        
        Maquina newMaquina;
        test ("New Maquina", ()
        {
            return new ClientMaquinaServices().NewGeneric().then((_newMaquina){
               
            newMaquina = _newMaquina;
            
            expect(_newMaquina.id != null, true, reason: "New Maquina Failed: got ${encode(_newMaquina)}");
            expect(_newMaquina.fabricacion.isBefore (new DateTime.now()), true);
            
            });
        });
        
        test ("Get", ()
        {
            services = new ClientMaquinaServices(newMaquina);
            
            return services.GetGeneric().then((getMaquina){
             
            expect(newMaquina.id, getMaquina.id);
            expect(newMaquina.categoria, getMaquina.categoria);
            expect(newMaquina.fabricacion, getMaquina.fabricacion);
            expect(newMaquina.href, getMaquina.href);
            expect(newMaquina.subcategoria, getMaquina.subcategoria);
            expect(newMaquina.modelo, getMaquina.modelo);
            
            });
        });
            
        Maquina deltaMaquina;
        test ("Update", ()
        {
            print ("Paso get");
            
            var delta = new Maquina()
                ..descripcion = "Esto es una maquina";
            
            return services.UpdateGeneric(delta).then((_deltaMaquina){
               
            deltaMaquina = _deltaMaquina;
            
            expect(newMaquina.categoria, _deltaMaquina.categoria);
            expect(newMaquina.fabricacion, _deltaMaquina.fabricacion);
            expect(newMaquina.href, _deltaMaquina.href);
            expect(newMaquina.subcategoria, _deltaMaquina.subcategoria);
            expect(newMaquina.modelo, _deltaMaquina.modelo);
            
            expect("Esto es una maquina", _deltaMaquina.descripcion);
            
            });
        });
        
        test ("Delete", ()
        {
            return services.DeleteGeneric().then((dbObj){ 
            expect(dbObj.id, deltaMaquina.id);
            
            });
        });
        
        test ("Posdelete", ()
        {
            return services.GetGeneric().then((noneMaquina){ 
                
            expect (noneMaquina.failed, true);
            });
        });
    });
}