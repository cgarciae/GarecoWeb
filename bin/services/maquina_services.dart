part of aristadart.server;

@app.Group('/${Col.maquina}')
@Encode()
@Catch()
class MaquinaServices extends AristaService<Maquina>
{
    MaquinaServices () : super (Col.maquina);
    
    @app.DefaultRoute(methods: const [app.POST])
    @Private()
    Future<Maquina> New () async
    {
        var maquina = new Maquina ()
            ..id = newId()
            ..owner = (new User()
                ..id = userId)
            ..descripcion = "Descripcion"
            ..categoria = Categoria.injectoras
            ..subcategoria = Categoria.subcategorias[Categoria.injectoras][0]
            ..fabricacion = new DateTime.now();
        
        return NewGeneric (maquina);
    }
    
    @app.Route('/:id', methods: const [app.GET])
    Future<Maquina> Get (String id) => GetGeneric(id);
    
    @app.Route('/:id', methods: const [app.PUT])
    @Private()
    Future<Maquina> Update (String id, @Decode() Maquina delta) async
    {
        await UpdateGeneric(id, delta);
        return Get (id);
    }
    
    @app.Route('/:id', methods: const [app.DELETE])
    @Private()
    Future<DbObj> Delete (String id) => DeleteGeneric(id);
    
    @app.Route('/all', methods: const [app.GET])
    @Private()
    Future<ListMaquinaResp> All () async
    {
        var list = await AllGeneric();
        
        return new ListMaquinaResp()
            ..maquinas = list;
    }
        
}