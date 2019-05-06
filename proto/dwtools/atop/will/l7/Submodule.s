( function _Submodule_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

//

let _ = wTools;
let Parent = _.Will.Resource;
let Self = function wWillSubmodule( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Submodule';

// --
// inter
// --

function OptionsFrom( o )
{
  _.assert( arguments.length === 1 );
  if( _.strIs( o ) || _.arrayIs( o ) )
  return { path : o }
  return o;
}

//

function unform()
{
  let submodule = this;
  let module = submodule.module;
  let rootModule = module.rootModule;

  if( !submodule.original && rootModule.allSubmoduleMap[ submodule.path ] )
  {
    debugger;
    _.assert( rootModule.allSubmoduleMap[ submodule.path ] === submodule.loadedModule );
    delete rootModule.allSubmoduleMap[ submodule.path ];
  }

  if( submodule.loadedModule )
  {
    // _.assert( submodule.loadedModule.associatedSubmodules === submodule );
    _.arrayRemoveOnceStrictly( submodule.loadedModule.associatedSubmodules, submodule );
    // submodule.loadedModule.associatedSubmodule = null;
    // submodule.loadedModule.finit();
    submodule.loadedModule = null;
  }

  return Parent.prototype.unform.call( submodule );
}

//

function form1()
{
  let submodule = this;

  _.assert( !!submodule.module );

  let rootModule = submodule.module.rootModule;
  let willf = submodule.willf;
  let will = rootModule.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  /* begin */

  // debugger;
  // if( !submodule.original )
  // {
  //   rootModule.allSubmoduleMap[ submodule.path ] = submodule;
  // }

  /* end */

  Parent.prototype.form1.call( submodule );
  return submodule;
}

//

function form3()
{
  let submodule = this;
  let module = submodule.module;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result = submodule;

  if( submodule.formed >= 3 )
  {
    if( submodule.loadedModule && submodule.loadedModule.hasAnyError() )
    {
      debugger;
      // _.assert( submodule.loadedModule.associatedSubmodule === submodule )
      // submodule.loadedModule.associatedSubmodule = null;
      _.arrayRemoveOnceStrictly( submodule.loadedModule.associatedSubmodules, submodule );
      submodule.loadedModule.finit();
      submodule.loadedModule = null;
      submodule.formed = 2;
    }
    else
    {
      return result;
    }
  }

  _.assert( arguments.length === 0 );
  _.assert( submodule.formed === 2 );
  _.assert( _.strIs( submodule.path ), 'not tested' );
  _.sure( _.strIs( submodule.path ) || _.arrayIs( submodule.path ), 'Path resource should have "path" field' );

  /* begin */

  if( !module.supermodule )
  result = submodule._load();

  /* end */

  submodule.formed = 3;
  return result;
}

//

function _load()
{
  let submodule = this;
  let module = submodule.module;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let rootModule = module.rootModule;

  _.assert( arguments.length === 0 );
  _.assert( submodule.formed === 2 );
  _.assert( submodule.loadedModule === null );
  _.assert( _.strIs( submodule.path ), 'not tested' );
  _.assert( !submodule.original );
  _.sure( _.strIs( submodule.path ) || _.arrayIs( submodule.path ), 'Path resource should have "path" field' );

  if( rootModule.allSubmoduleMap[ submodule.path ] )
  {
    debugger;
    submodule.loadedModule = rootModule.allSubmoduleMap[ submodule.path ];
    return submodule.loadedModule.ready.split()
  }

  /* */

  submodule.loadedModule = will.Module
  ({
    will : will,
    alias : submodule.name,
    willFilesPath : path.join( module.inPath, submodule.path ),
    supermodule : module,
    associatedSubmodules : [ submodule ],
  }).preform();

  rootModule.allSubmoduleMap[ submodule.path ] = submodule.loadedModule;
  // debugger;

  submodule.loadedModule.willFilesFind({ isOutFile : 1 });
  submodule.loadedModule.willFilesOpen();
  submodule.loadedModule.submodulesFormSkip();
  submodule.loadedModule.resourcesForm();

  submodule.loadedModule.willFilesFindReady.finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( 'Failed to open', submodule.nickName, 'at', _.strQuote( submodule.loadedModule.dirPath ), '\n', err );
    return arg;
  });

  // debugger;
  submodule.loadedModule.ready.finally( ( err, arg ) =>
  {
    // debugger;
    if( err )
    {
      if( rootModule.allSubmoduleMap[ submodule.path ] === submodule.loadedModule )
      {
        // debugger;
        delete rootModule.allSubmoduleMap[ submodule.path ]
      }
      if( will.verbosity >= 3 )
      logger.error( ' ! Failed to read ' + submodule.decoratedNickName + ', try to download it with ' + _.color.strFormat( '.submodules.download', 'code' ) + ' or even ' + _.color.strFormat( '.clean', 'code' ) + ' it before downloading' );
      if( will.verbosity >= 5 || !submodule.loadedModule || submodule.loadedModule.isOpened() )
      {
        if( will.verbosity < 5 )
        _.errLogOnce( _.errBriefly( err ) );
        else
        _.errLogOnce( err );
      }
      else
      {
        _.errAttend( err );
      }
      throw err;
    }
    return arg || null;
  });

  /* */

  return submodule.loadedModule.ready.split().finally( ( err, arg ) =>
  {
    // debugger;
    return null;
  });

}

//

function resolve_body( o )
{
  let submodule = this;
  let module = submodule.module;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let module2 = submodule.loadedModule || module;

  _.assert( arguments.length === 1 );
  _.assert( o.currentContext === null || o.currentContext === submodule )

  o.currentContext = submodule;

  let resolved = module2.resolve.body.call( module2, o );

  return resolved;
}

_.routineExtend( resolve_body, _.Will.Resource.prototype.resolve.body );
let resolve = _.routineFromPreAndBody( _.Will.Resource.prototype.resolve.pre, resolve_body );

//

function isDownloadedGet()
{
  let submodule = this;
  let module = submodule.module;

  if( !submodule.loadedModule )
  return false;

  return submodule.loadedModule.isDownloaded;
}

//

function dataExport()
{
  let submodule = this;
  let module = submodule.module;
  let willf = submodule.willf;
  let will = module.will;

  let result = Parent.prototype.dataExport.apply( this, arguments );

  if( result === undefined )
  return result;

  debugger;

  return result;
}

dataExport.defaults = Object.create( _.Will.Resource.prototype.dataExport.defaults );

//

function infoExport()
{
  let submodule = this;
  let module = submodule.module;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let result = Parent.prototype.infoExport.call( submodule );
  let tab = '  ';

  if( result )
  result += '\n';
  result += tab + 'isDownloaded : ' + _.toStr( submodule.isDownloaded );

  if( submodule.loadedModule )
  {
    result += '\n'
    let module2 = submodule.loadedModule
    result += tab + 'Exported builds : ' + _.toStr( _.mapKeys( module2.exportedMap ) );
  }

  return result;
}

// --
// relations
// --

let Composes =
{

  path : null,
  description : null,
  criterion : null,
  inherit : _.define.own([]),

}

let Aggregates =
{
  name : null,
}

let Associates =
{
  data : null,
}

let Restricts =
{
  loadedModule : null,
}

let Statics =
{
  OptionsFrom : OptionsFrom,
  MapName : 'submoduleMap',
  KindName : 'submodule',
}

let Accessors =
{
  isDownloaded : { getter : isDownloadedGet, readOnly : 1 },
}

let Forbids =
{
}

// --
// declare
// --

let Proto =
{

  // inter

  OptionsFrom,
  unform,
  form1,
  form3,

  _load,

  resolve,

  isDownloadedGet,

  dataExport,
  infoExport,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Accessors,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

_.staticDeclare
({
  prototype : _.Will.prototype,
  name : Self.shortName,
  value : Self,
});

})();
