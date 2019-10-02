( function _Module_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

//

let _ = wTools;
let Parent = _.Will.AbstractModule;
let Self = function wWillOpenedModule( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'OpenedModule';

// --
// inter
// --

function finit()
{
  let module = this;
  let will = module.will;
  let rootModule = module.rootModule;
  let logger = will.logger;

  if( will.verosity >= 5 )
  logger.log( module.qualifiedName, 'finit.begin' );

  _.assert( !module.finitedIs() );

  try
  {

    if( module.peerModule )
    {
      let peerModule = module.peerModule;
      _.assert( !peerModule.finitedIs() );
      _.assert( peerModule.peerModule === module );
      peerModule.peerModule = null;
      module.peerModule = null;
      if( !peerModule.isUsed() )
      peerModule.finit();
    }

    module.unform();
  }
  catch( err )
  {
    logger.log( _.errOnce( err ) );
    debugger;
  }

  try
  {

    module._nameUnregister();
    module.about.finit();

    let finited = _.err( 'Finited' );
    _.errAttend( finited );
    finited.finited = true;
    module.stager.cancel();
    module.stager.stagesState( 'skipping', true );
    module.stager.stageError( 'formed', finited );

    let userArray = module.userArray.slice();
    userArray.forEach( ( opener ) =>
    {
      opener.openedModule = null;
    });
    _.assert( module.userArray.length === 0 );
    userArray.forEach( ( opener ) =>
    {
      if( opener.isUsed() )
      opener.close();
      else
      opener.finit();
    });

    if( module.peerModule )
    {
      let peerModule = module.peerModule;
      _.assert( peerModule.peerModule === module );
      peerModule.peerModule = null;
      module.peerModule = null;
      if( !peerModule.isUsed() )
      peerModule.finit();
    }

  }
  catch( err )
  {
    logger.log( _.errOnce( err ) );
    debugger;
  }

  _.assert( Object.keys( module.exportedMap ).length === 0 );
  _.assert( Object.keys( module.buildMap ).length === 0 );
  _.assert( Object.keys( module.stepMap ).length === 0 );
  _.assert( Object.keys( module.reflectorMap ).length === 0 );
  _.assert( Object.keys( module.pathResourceMap ).length === 0 );
  _.assert( Object.keys( module.submoduleMap ).length === 0 );
  _.assert( _.workpiece.isFinited( module.about ) );

  let result = Parent.prototype.finit.apply( module, arguments );

  if( will.verosity >= 5 )
  logger.log( module.qualifiedName, 'finit.end' );

  return result;
}

//

function init( o )
{
  let module = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  module.pathResourceMap = module.pathResourceMap || Object.create( null );

  Parent.prototype.init.apply( module, arguments );

  module.precopy( o );

  let will = o.will;
  let logger = will.logger;
  _.assert( !!will );

  module.stager = new _.Stager
  ({
    object : module,
    verbosity : Math.max( Math.min( will.verbosity, will.verboseStaging ), will.verbosity - 6 ),
    stageNames :        [ 'preformed',        'picked',             'opened',             'attachedWillfilesFormed',      'peerModulesFormed',        'subModulesFormed',                 'resourcesFormed',          'formed' ],
    consequences :      [ 'preformReady',     'pickedReady',        'openedReady',        'attachedWillfilesFormReady',   'peerModulesFormReady',     'subModulesFormReady',              'resourcesFormReady',       'ready' ],
    onPerform :         [ '_preform',         '_willfilesPicked',   '_willfilesOpen',     '_attachedWillfilesForm',       '_peerModulesForm',         '_subModulesForm',                  '_resourcesForm',           null ],
    onBegin :           [ null,               null,                 null,                 null,                           null,                       null,                               null,                       null ],
    onEnd :             [ null,               null,                 null,                 null,                           null,                       null, /*module._willfilesReadEnd,*/ null,                       module._formEnd ],
  });

  module.stager.stageStatePausing( 'picked', 1 );
  module.stager.stageStateSkipping( 'resourcesFormed', 1 );

  module.predefinedForm();
  module.moduleWithNameMap = Object.create( null );

  _.assert( !!o );
  if( o )
  module.copy( o );

  if( module.willfilePath === null )
  module.willfilePath = _.select( module.willfilesArray, '*/filePath' );

  module._filePathChanged();
  module._nameChanged();

  module.ready.tap( ( err, arg ) =>
  {
    if( err )
    for( let u = 0 ; u < module.userArray.length ; u++ )
    {
      let opener = module.userArray[ u ];
      _.assert( opener instanceof will.ModuleOpener );
      opener.error = opener.error || err;
    }
  });

  if( will.verosity >= 5 )
  logger.log( module.qualifiedName, 'init' );

  // if( module.id === 55 )
  // debugger;

}

//

function openerMake()
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 0 ); debugger; xxx

  let o2 = module.optionsForOpenerExport();
  let opener = will.openerMake({ opener : o2 });

  return opener;
}

// //
//
// function finitMaybe( user )
// {
//   let module = this;
//
//   if( !module.isUsed() )
//   {
//     module.finit();
//     return true;
//   }
//
//   return false;
// }

//

function releasedBy( user )
{
  let module = this;
  _.arrayRemoveOnceStrictly( module.userArray, user );
  return true;
}

//

function usedBy( user )
{
  let module = this;
  let will = module.will;
  _.arrayAppendOnceStrictly( module.userArray, user );
  return module;
}

//

function isUsedBy( user )
{
  let module = this;
  let will = module.will;
  if( user instanceof Self )
  return user.peerModule === module;
  return _.arrayHas( module.userArray, user );
}

//

function isUsed()
{
  let module = this;
  if( module.userArray.length )
  return true;
  if( module.peerModule && module.peerModule.userArray.length )
  return true;
  return false;
}

//

function precopy( o )
{
  let module = this;

  if( o.will )
  module.will = o.will;

  if( o.superRelations )
  module.superRelations = o.superRelations;

  if( o.original )
  module.original = o.original;

  if( !module.rootModule && !o.rootModule )
  o.rootModule = module;

  if( o.rootModule )
  module.rootModule = o.rootModule;

  return o;
}

//

function copy( o )
{
  let module = this;

  module.precopy( o );

  let result = _.Copyable.prototype.copy.apply( module, arguments );

  let names =
  {
    willfilesPath : null,
    inPath : null,
    outPath : null,
    localPath : null,
    remotePath : null,
  }

  for( let n in names )
  {
    if( o[ n ] !== undefined )
    module[ n ] = o[ n ];
  }

  _.assert( result.currentRemotePath === module.currentRemotePath );

  return result;
}

//

function clone()
{
  let module = this;

  _.assert( arguments.length === 0 );

  let result = module.cloneExtending({});

  return result;
}

//

function cloneExtending( o )
{
  let module = this;

  _.assert( arguments.length === 1 );

  if( o.original === undefined )
  o.original = module.original || module;

  if( o.willfilesArray === undefined )
  o.willfilesArray = [];

  let result = _.Copyable.prototype.cloneExtending.call( module, o );

  return result;
}

//

function unform()
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 0 );

  if( module.peerModule )
  {
    let peerModule = module.peerModule;
    _.assert( !peerModule.finitedIs() );
    _.assert( peerModule.peerModule === module );
    peerModule.peerModule = null;
    module.peerModule = null;
  }

  module.close();
  will.modulePathUnregister( module );

  _.assert( module.willfilesArray.length === 0 );
  _.assert( Object.keys( module.willfileWithRoleMap ).length === 0 );

  if( module.stager.stageStatePerformed( 'preformed' ) )
  {
    will.moduleIdUnregister( module );
  }

  _.assert( !_.arrayHas( _.mapVals( will.moduleWithIdMap ), module ) );
  _.assert( !_.arrayHas( _.mapVals( will.moduleWithCommonPathMap ), module ) );
  _.assert( will.moduleWithIdMap[ module.id ] !== module );
  _.assert( !_.arrayHas( will.modulesArray, module ) );

  for( let i in module.pathResourceMap )
  module.pathResourceMap[ i ].finit();

  _.assert( Object.keys( module.exportedMap ).length === 0 );
  _.assert( Object.keys( module.buildMap ).length === 0 );
  _.assert( Object.keys( module.stepMap ).length === 0 );
  _.assert( Object.keys( module.reflectorMap ).length === 0 );
  _.assert( Object.keys( module.pathResourceMap ).length === 0 );
  _.assert( Object.keys( module.pathMap ).length === 0 );
  _.assert( Object.keys( module.submoduleMap ).length === 0 );

  return module;
}

//

function preform()
{
  let module = this;
  let will = module.will;
  let con = new _.Consequence().take( null );

  _.assert( arguments.length === 0 );
  _.assert( !module.preformReady.resourcesCount() )
  _.assert( !module.preformed );
  _.assert( !module.stager.stageStateEnded( 'preformed' ) );

  // debugger;
  module.stager.stageStatePausing( 'preformed', 0 );
  module.stager.tick();
  // debugger;

  _.assert( module.stager.stageStateEnded( 'preformed' ) );

  return module;
}

//

function _preform()
{
  let module = this;
  let will = module.will;

  /* */

  _.assert( arguments.length === 0 );
  _.assert( !!module.will );
  _.assert( _.strsAreAll( module.willfilesPath ) || _.strIs( module.dirPath ), 'Expects willfilesPath or dirPath' );

  if( module.pathResourceMap.in.path === null )
  module.pathResourceMap.in.path = '.';
  if( module.pathResourceMap.out.path === null )
  module.pathResourceMap.out.path = '.';

  /* */

  will.moduleIdRegister( module );

  /* */

  _.assert( arguments.length === 0 );
  _.assert( !!module.will );
  _.assert( will.moduleWithIdMap[ module.id ] === module );
  _.assert( module.dirPath === null || _.strDefined( module.dirPath ) );
  _.assert( !!module.willfilesPath || !!module.dirPath );
  _.assert( module.rootModule instanceof will.OpenedModule );

  /* */

  return module;
}

//

function predefinedForm()
{
  let module = this;
  let will = module.will;
  let Predefined = will.Predefined;

  _.assert( arguments.length === 0 );
  _.assert( module.predefinedFormed === 0 );
  module.predefinedFormed = 1;

  /* */

  path
  ({
    name : 'in',
    path : '.',
    writable : 1,
    exportable : 1,
    importableFromIn : 1,
    importableFromOut : 1,
    criterion :
    {
      predefined : 0,
    },
  })

  path
  ({
    name : 'out',
    path : '.',
    writable : 1,
    exportable : 1,
    importableFromIn : 1,
    importableFromOut : 1,
    criterion :
    {
      predefined : 0,
    },
  })

  path
  ({
    name : 'module.willfiles',
    path : null,
    writable : 0,
    exportable : 1,
    importableFromIn : 0,
    importableFromOut : 0,
  })

  path
  ({
    name : 'module.original.willfiles',
    path : null,
    writable : 0,
    exportable : 1,
    importableFromIn : 0,
    importableFromOut : 1,
  })

  path
  ({
    name : 'module.peer.willfiles',
    path : null,
    writable : 0,
    exportable : 1,
    importableFromIn : 0,
    importableFromOut : 1,
  })

  path
  ({
    name : 'module.dir',
    path : null,
    writable : 0,
    exportable : 0,
    importableFromIn : 0,
    importableFromOut : 0,
  })

  path
  ({
    name : 'module.common',
    path : null,
    writable : 0,
    exportable : 1,
    importableFromIn : 0,
    importableFromOut : 0,
  });

  path
  ({
    name : 'local',
    path : null,
    writable : 1,
    exportable : 1,
    importableFromIn : 1,
    importableFromOut : 0,
  })

  path
  ({
    name : 'remote',
    path : null,
    writable : 1,
    exportable : 1,
    importableFromIn : 0,
    importableFromOut : 1,
  })

  path
  ({
    name : 'current.remote',
    path : null,
    writable : 0,
    exportable : 0,
    importableFromIn : 0,
    importableFromOut : 0,
  })

  path
  ({
    name : 'will',
    path : _.path.join( __dirname, '../Exec' ),
    writable : 0,
    exportable : 0,
    importableFromIn : 0,
    importableFromOut : 0,
  })
  _.assert( will.fileProvider.path.s.allAreAbsolute( module.pathResourceMap[ 'will' ].path ) );

  /* */

  step
  ({
    name : 'files.delete',
    stepRoutine : Predefined.stepRoutineDelete,
  })

  step
  ({
    name : 'files.reflect',
    stepRoutine : Predefined.stepRoutineReflect,
  })

  step
  ({
    name : 'timelapse.begin',
    stepRoutine : Predefined.stepRoutineTimelapseBegin,
  })

  step
  ({
    name : 'timelapse.end',
    stepRoutine : Predefined.stepRoutineTimelapseEnd,
  })

  step
  ({
    name : 'js.run',
    stepRoutine : Predefined.stepRoutineJs,
  })

  step
  ({
    name : 'shell.run',
    stepRoutine : Predefined.stepRoutineShell,
  })

  step
  ({
    name : 'files.transpile',
    stepRoutine : Predefined.stepRoutineTranspile,
  })

  step
  ({
    name : 'file.view',
    stepRoutine : Predefined.stepRoutineView,
  })

  step
  ({
    name : 'npm.generate',
    stepRoutine : Predefined.stepRoutineNpmGenerate,
  })

  step
  ({
    name : 'submodules.download',
    stepRoutine : Predefined.stepRoutineSubmodulesDownload,
  })

  step
  ({
    name : 'submodules.update',
    stepRoutine : Predefined.stepRoutineSubmodulesUpdate,
  })

  step
  ({
    name : 'submodules.reload',
    stepRoutine : Predefined.stepRoutineSubmodulesReload,
  })

  step
  ({
    name : 'submodules.clean',
    stepRoutine : Predefined.stepRoutineSubmodulesClean,
  })

  step
  ({
    name : 'clean',
    stepRoutine : Predefined.stepRoutineClean,
  })

  step
  ({
    name : 'module.export',
    stepRoutine : Predefined.stepRoutineExport,
  })

  /* */

  reflector
  ({
    name : 'predefined.common',
    src :
    {
      maskAll :
      {
        excludeAny :
        [
          /(\W|^)node_modules(\W|$)/,
          /\.unique$/,
          /\.git$/,
          /\.svn$/,
          /\.hg$/,
          /\.DS_Store$/,
          /(^|\/)-/,
        ],
      }
    },
  });

  reflector
  ({
    name : 'predefined.debug.v1',
    src :
    {
      maskAll :
      {
        excludeAny : [ /\.release($|\.|\/)/i ],
      }
    },
    criterion :
    {
      debug : 1,
    },
  });

  reflector
  ({
    name : 'predefined.debug.v2',
    src :
    {
      maskAll :
      {
        excludeAny : [ /\.release($|\.|\/)/i ],
      }
    },
    criterion :
    {
      debug : 'debug',
    },
  });

  reflector
  ({
    name : 'predefined.release.v1',
    src :
    {
      maskAll :
      {
        excludeAny : [ /\.debug($|\.|\/)/i, /\.experiment($|\.|\/)/i ],
        // excludeAny : [ /\.debug($|\.|\/)/i, /\.test($|\.|\/)/i, /\.experiment($|\.|\/)/i ],
      }
    },
    criterion :
    {
      debug : 0,
    },
  });

  reflector
  ({
    name : 'predefined.release.v2',
    src :
    {
      maskAll :
      {
        excludeAny : [ /\.debug($|\.|\/)/i, /\.experiment($|\.|\/)/i ],
        // excludeAny : [ /\.debug($|\.|\/)/i, /\.test($|\.|\/)/i, /\.experiment($|\.|\/)/i ],
      }
    },
    criterion :
    {
      debug : 'release',
    },
  });

  // _.assert( module.pathResourceMap[ 'module.common' ].importable === undefined );
  _.assert( !module.pathResourceMap[ 'module.common' ].importableFromIn );
  _.assert( !module.pathResourceMap[ 'module.common' ].importableFromOut );

/*
  .predefined.common :
    src :
      maskAll :
        excludeAny :
        - !!js/regexp '/(^|\/)-/'

  .predefined.debug :
    inherit : .predefined.common
    src :
      maskAll :
        excludeAny :
        - !!js/regexp '/\.release($|\.|\/)/i'

  .predefined.release :
    inherit : .predefined.common
    src :
      maskAll :
        excludeAny :
        - !!js/regexp '/\.debug($|\.|\/)/i'
        - !!js/regexp '/\.test($|\.|\/)/i'
        - !!js/regexp '/\.experiment($|\.|\/)/i'
*/

  /* - */

  function prepare( defaults, o )
  {

    o.criterion = o.criterion || Object.create( null );

    if( o.importable !== undefined && o.importable !== null )
    {
      if( o.importableFromIn === undefined || o.importableFromIn === null )
      o.importableFromIn = o.importable;
      if( o.importableFromOut === undefined || o.importableFromOut === null )
      o.importableFromOut = o.importable;
    }

    delete o.importable;

    _.mapSupplement( o, defaults );
    _.mapSupplement( o.criterion, defaults.criterion );

    _.assert( o.criterion !== defaults.criterion );
    _.assert( arguments.length === 2 );

    return o;
  }

  /* */

  function path( o )
  {

    let defaults =
    {
      module : module,
      writable : 0,
      exportable : 0,
      importableFromIn : 1,
      importableFromOut : 1,
      criterion :
      {
        predefined : 1,
      }
    }

    o = prepare( defaults, o );

    _.assert( arguments.length === 1 );

    let result = module.pathResourceMap[ o.name ];
    if( result )
    {
      let criterion = o.criterion;
      delete o.criterion;
      result.copy( o );
      _.mapExtend( result.criterion, criterion );
    }
    else
    {
      result = new will.PathResource( o );
    }

    result.form1();

    _.assert( !!result.writable === !!o.writable );

    return result;
  }

  /* */

  function step( o )
  {
    if( module.stepMap[ o.name ] )
    return module.stepMap[ o.name ].form1();

    let defaults =
    {
      module : module,
      writable : 0,
      exportable : 0,
      importableFromIn : 0,
      importableFromOut : 0,
      criterion :
      {
        predefined : 1,
      }
    }

    // o.criterion = o.criterion || Object.create( null );
    //
    // _.mapSupplement( o, defaults );
    // _.mapSupplement( o.criterion, defaults.criterion );
    //
    // _.assert( o.criterion !== defaults.criterion );

    o = prepare( defaults, o );

    _.assert( arguments.length === 1 );

    let result = new will.Step( o ).form1();
    result.writable = 0;
    return result;
  }

  /* */

  function reflector( o )
  {
    if( module.reflectorMap[ o.name ] )
    return module.reflectorMap[ o.name ].form1();

    let defaults =
    {
      module : module,
      writable : 0,
      exportable : 0,
      importableFromIn : 0,
      importableFromOut : 0,
      criterion :
      {
        predefined : 1,
      }
    }

    let o2 = Object.create( null );
    o2.resource = o;
    // o2.resource = _.mapExtend( null, defaults, o );
    // o2.resource.criterion = _.mapExtend( null, defaults.criterion, o.criterion || {} );

    // _.mapSupplement( o, defaults );
    // _.mapSupplement( o.criterion, defaults.criterion );

    o = prepare( defaults, o2.resource );

    _.assert( !!o2.resource.criterion );
    _.assert( arguments.length === 1 );

    let result = will.Reflector.MakeForEachCriterion( o2 );
    return result;
  }

}

//

function upform( o )
{
  let module = this;
  let will = module.will;

  o = _.routineOptions( upform, arguments );
  module.optionsFormingForward( o );

  // debugger;

  if( o.attachedWillfilesFormed )
  if( !module.stager.stageStatePerformed( 'attachedWillfilesFormed' ) )
  module.stager.stageReset( 'attachedWillfilesFormed' );

  if( o.peerModulesFormed )
  if( !module.stager.stageStatePerformed( 'peerModulesFormed' ) )
  module.stager.stageReset( 'peerModulesFormed' );

  if( o.subModulesFormed )
  if( !module.stager.stageStatePerformed( 'subModulesFormed' ) )
  module.stager.stageReset( 'subModulesFormed' );

  if( o.resourcesFormed )
  if( !module.stager.stageStatePerformed( 'resourcesFormed' ) )
  module.stager.stageReset( 'resourcesFormed' );

  module.stager.tick();
  return module.ready;
}

var defaults = upform.defaults = _.mapExtend( null, Parent.prototype.optionsFormingForward.defaults );
defaults.all = 1;

// {
//   all : 1,
//   attachedWillfilesFormed : null,
//   peerModulesFormed : null,
//   subModulesFormed : null,
//   resourcesFormed : null,
// }

//

function reform_( o )
{
  let module = this;
  let will = module.will;

  o = _.routineOptions( reform_, arguments );
  module.optionsFormingForward( o );

  if( o.attachedWillfilesFormed )
  module.stager.stageReset( 'attachedWillfilesFormed' );

  if( o.peerModulesFormed )
  module.stager.stageReset( 'peerModulesFormed' );

  if( o.subModulesFormed )
  module.stager.stageReset( 'subModulesFormed' );

  if( o.resourcesFormed )
  module.stager.stageReset( 'resourcesFormed' );

  module.stager.tick();
  return module.ready;
}

var defaults = reform_.defaults = _.mapExtend( null, Parent.prototype.optionsFormingForward.defaults );
defaults.all = 0;

// reform_.defaults =
// {
//   all : 0,
//   attachedWillfilesFormed : null,
//   peerModulesFormed : null,
//   subModulesFormed : null,
//   resourcesFormed : null,
// }

// --
// opener
// --

function isOpened()
{
  let module = this;
  return module.willfilesArray.length > 0 && module.stager.stageStateEnded( 'opened' );
}

//

function isValid()
{
  let module = this;
  return module.stager.isValid();
}

//

function isConsistent( o )
{
  let module = this;

  o = _.routineOptions( isConsistent, arguments );
  _.assert( o.recursive === 0 );

  let willfiles = module.willfilesEach({ recursive : o.recursive, withPeers : 0 });

  return willfiles.every( ( willfile ) =>
  {
    _.assert( _.boolLike( willfile.isOut ) );
    if( !willfile.isOut )
    return true;
    _.assert( willfile.openedModule instanceof module.Self );
    if( !willfile.openedModule.peerModule )
    return false;
    _.assert( !!willfile.openedModule.peerModule );
    if( willfile.openedModule.peerModule )
    return willfile.openedModule.peerModule.willfilesArray.every( ( willfile2 ) =>
    {
      return willfile.isConsistentWith( willfile2 );
    });
  });

}

isConsistent.defaults =
{
  recursive : 0,
}

//

function isFull( o )
{
  let module = this;
  if( !module.isOpened() )
  return false;

  o = _.routineOptions( isFull, arguments );
  o.all = o.all || Object.create( null );
  o.all.all = 1;
  o.all = module.optionsFormingForward( o.all );

  let states = module.stager.stagesState( 'performed' )
  _.mapSupplement( o.all, _.map( states, () => true ) );
  states = _.only( states, o.all ); /* xxx : review mapOnly / mapBut */

  return _.all( states );
}

var defaults = isFull.defaults = Object.create( null );
defaults.all = null;

//

function close()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( !module.finitedIs() );
  _.assert( arguments.length === 0 );

  // /* update openers first, maybe */
  //
  // openers.pathsFromModule( module );

  /* */

  for( let i in module.exportedMap )
  module.exportedMap[ i ].finit();
  for( let i in module.buildMap )
  module.buildMap[ i ].finit();
  for( let i in module.stepMap )
  module.stepMap[ i ].finit();
  for( let i in module.reflectorMap )
  module.reflectorMap[ i ].finit();
  for( let i in module.pathResourceMap )
  {
    if( !module.pathResourceMap[ i ].criterion || !module.pathResourceMap[ i ].criterion.predefined )
    module.pathResourceMap[ i ].finit();
  }

  for( let i in module.submoduleMap )
  module.submoduleMap[ i ].finit();

  _.assert( Object.keys( module.exportedMap ).length === 0 );
  _.assert( Object.keys( module.buildMap ).length === 0 );
  _.assert( Object.keys( module.stepMap ).length === 0 );
  _.assert( Object.keys( module.reflectorMap ).length === 0 );
  _.assert( Object.keys( module.submoduleMap ).length === 0 );

  /* */

  module._willfilesRelease( module.willfilesArray );
  module._willfilesRelease( module.storedWillfilesArray );

  /* */

  _.assert( module.willfilesArray.length === 0 );
  _.assert( Object.keys( module.willfileWithRoleMap ).length === 0 );

  module.stager.cancel({ but : [ 'preformed' ] });

}

//

function _formEnd()
{
  let module = this;
  return null;
}

// --
// willfiles
// --

function _willfilesPicked()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( module.willfilesArray.length > 0 );
  // _.assert( !!module.mainOpener, 'Expects specified {- module.mainOpener -} at th point' );

  // debugger;
  // let result = module._attachedModulesOpen();
  // debugger;
  // return result;

  return null;
}

//

function willfilesOpen()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  module.stager.stageStatePausing( 'opened', 0 );
  module.stager.tick();

  return module.stager.stageConsequence( 'opened' );
}

//

function _willfilesOpen()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let con = new _.Consequence().take( null );
  let time = _.timeNow();

  _.assert( arguments.length === 0 );
  _.assert( _.boolLike( module.isOut ), 'Expects defined {- module.isOut -}' );
  _.sure
  (
    !!_.mapKeys( module.willfileWithRoleMap ).length && !!module.willfilesArray.length,
    () => 'Found no will file at ' + _.strQuote( module.dirPath )
  );

  /* */

  for( let i = module.willfilesArray.length-1 ; i >= 0 ; i-- )
  {
    let willf = module.willfilesArray[ i ];
    _.assert( willf.openedModule === null || willf.openedModule === module );
    willf.openedModule = module;
    _.assert( willf.openedModule === module );
  }

  /* */

  for( let i = 0 ; i < module.willfilesArray.length ; i++ )
  {
    let willfile = module.willfilesArray[ i ];
    _.assert( willfile.formed === 1 || willfile.formed === 2 || willfile.formed === 3, 'not expected' );
    con.then( ( arg ) => willfile.form() );
  }

  /* */

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err );
    module._nameChanged();
    return arg;
  });

  /* */

  return con.split();
}

//

function _willfilesReadBegin()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  will._willfilesReadBegin();
  // module.willfilesReadBeginTime = _.timeNow();

  return null;
}

//

function _willfilesReadEnd()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  will._willfilesReadEnd( module );

  // if( will.verbosity >= 2 )
  // if( module === module.rootModule && !module.original )
  // {
  //   if( !module.willfilesReadTimeReported )
  //   logger.log( ' . Read', module.willfilesResolve().length, 'willfile(s) in', _.timeSpent( module.willfilesReadBeginTime ), '\n' );
  //   module.willfilesReadTimeReported = 1;
  // }

  return null;
}

//

function willfileUnregister( willf )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  // if( willf.storageModule === module )
  // {
  //   _.assert( willf.storageModule !== willf.openedModule );
  //   _.arrayRemoveOnceStrictly( module.storedWillfilesArray, willf );
  //   willf.storageModule = null;
  //   return;
  // }

  _.assert( willf.openedModule === module || willf.openedModule === null );
  willf.openedModule = null;

  Parent.prototype.willfileUnregister.apply( module, arguments );
}

//

function willfileRegister( willf )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 1 );

  if( _.arrayIs( willf ) )
  {
    debugger;
    willf.forEach( ( willf ) => module.willfileRegister( willf ) );
    return;
  }

  // if( willf.storageModule === module )
  // {
  //   _.assert( willf.storageModule !== willf.openedModule );
  //   _.arrayAppendOnceStrictly( module.storedWillfilesArray, willf );
  //   return;
  // }

  _.assert( willf.openedModule === null || willf.openedModule === module );
  willf.openedModule = module;

  Parent.prototype.willfileRegister.apply( module, arguments );
}

//

function _willfilesExport()
{
  let module = this;
  let will = module.will;
  let result = Object.create( null );

  module.willfilesEach( handeWillFile );

  return result;

  function handeWillFile( willfile )
  {
    _.assert( _.objectIs( willfile.data ) );
    result[ willfile.filePath ] = willfile.data;
  }

}

//

function willfilesEach( o )
{
  let module = this;
  let will = module.will;
  let result = []

  if( _.routineIs( arguments[ 0 ] ) )
  o = { onUp : arguments[ 0 ] }
  o = _.routineOptions( willfilesEach, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  let o2 = Object.create( null );
  o2.recursive = o.recursive;
  o2.withStem = o.withStem;
  o2.withPeers = o.withPeers;
  o2.onUp = handleUp;

  module.modulesEach( o2 );

  return result;

  // for( let w = 0 ; w < module.willfilesArray.length ; w++ )
  // {
  //   let willfile = module.willfilesArray[ w ];
  //   onEach( willfile )
  // }
  //
  // for( let s in module.submoduleMap )
  // {
  //   let submodule = module.submoduleMap[ s ];
  //   if( !submodule.opener )
  //   continue;
  //
  //   for( let w = 0 ; w < submodule.opener.willfilesArray.length ; w++ )
  //   {
  //     let willfile = submodule.opener.willfilesArray[ w ];
  //     onEach( willfile )
  //   }
  //
  // }

  function handleUp( module2 )
  {

    for( let w = 0 ; w < module2.willfilesArray.length ; w++ )
    {
      let willfile = module2.willfilesArray[ w ];
      if( o.onUp )
      o.onUp.call( module, willfile );
      result.push( willfile );
    }

  }

}

willfilesEach.defaults =
{
  recursive : 0,
  withStem : 1,
  withPeers : 0,
  onUp : null,
}

//

function _attachedWillfilesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!module );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  let con = _.Consequence().take( null );

  con.then( ( arg ) =>
  {
    return module._attachedWillfilesOpenFromData();
  });

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw err;
    return arg;
  });

  return con.split();
}

//

function _attachedWillfilesOpenFromData( o )
{
  let module = this;
  let will = module.will;

  o = _.routineOptions( _attachedWillfilesOpenFromData, arguments );
  o.rootModule = o.rootModule || module.rootModule || module;
  o.willfilesArray = o.willfilesArray || module.willfilesArray;

  for( let f = 0 ; f < o.willfilesArray.length ; f++ )
  {
    let willfile = o.willfilesArray[ f ];

    if( !willfile.isOut )
    continue;

    if( !willfile.structure.format )
    continue;

    willfile._read();

    for( let modulePath in willfile.structure.module )
    {
      let moduleStructure = willfile.structure.module[ modulePath ];

      if( _.arrayHas( willfile.structure.root, modulePath ) )
      continue;

      module._attachedWillfileOpenFromData
      ({
        modulePath : modulePath,
        structure : moduleStructure,
        rootModule : o.rootModule,
        storagePath : willfile.filePath,
        storageWillfile : willfile,
      });
    }

  }

  return null;
}

_attachedWillfilesOpenFromData.defaults =
{
  willfilesArray : null,
  rootModule : null,
}

//

function _attachedWillfileOpenFromData( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  o = _.routineOptions( _attachedWillfileOpenFromData, arguments );

  let modulePath = path.join( module.dirPath, o.modulePath );
  let filePath = modulePath;
  if( o.structure.path && o.structure.path[ 'module.willfiles' ] )
  {
    let moduleWillfilesPath = o.structure.path[ 'module.willfiles' ];
    if( _.mapIs( moduleWillfilesPath ) )
    moduleWillfilesPath = moduleWillfilesPath.path;
    if( moduleWillfilesPath )
    filePath = path.s.join( path.s.dirFirst( modulePath ), moduleWillfilesPath );
  }

  let willfOptions =
  {
    filePath : filePath,
    structure : o.structure,
    storagePath : o.storagePath,
    storageWillfile : o.storageWillfile,
    // storageModule : module,
  }

  return will.willfileFor({ willf : willfOptions, combining : 'supplement' });
}

_attachedWillfileOpenFromData.defaults =
{
  modulePath : null,
  storagePath : null,
  storageWillfile : null,
  structure : null,
  rootModule : null,
}

// --
// build / export
// --

function exportAuto()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let clonePath = module.cloneDirPathGet();

  debugger;
  _.assert( 'not implemented' );

  // _.assert( arguments.length === 0 );
  // _.assert( !!module.submoduleAssociation );
  // _.assert( !!module.submoduleAssociation.autoExporting );
  // _.assert( !module.pickedWillfileData );
  // _.assert( !module.pickedWillfilesPath );
  //
  // let autoWillfileData =
  // {
  //   'about' :
  //   {
  //     'name' : 'Extend',
  //     'version' : '0.1.0'
  //   },
  //   'path' :
  //   {
  //     'in' : '..',
  //     'out' : '.module',
  //     'remote' : 'git+https :///github.com/Wandalen/wProto.git',
  //     'local' : '.module/Extend',
  //     'export' : '{path::local}/proto'
  //   },
  //   'reflector' :
  //   {
  //     'download' :
  //     {
  //       'src' : 'path::remote',
  //       'dst' : 'path::local'
  //     }
  //   },
  //   'step' :
  //   {
  //     'export.common' :
  //     {
  //       'export' : 'path::export',
  //       'tar' : 0
  //     }
  //   },
  //   'build' :
  //   {
  //     'export' :
  //     {
  //       'criterion' :
  //       {
  //         'default' : 1,
  //         'export' : 1
  //       },
  //       'steps' :
  //       [
  //         'step::download',
  //         'step::export.common'
  //       ]
  //     }
  //   }
  // }
  //
  // module.pickedWillfileData = autoWillfileData;
  // module.pickedWillfilesPath = clonePath + module.aliasName;
  // module._willfilesFindPickedFile()
  //
  // debugger;

}

//

function moduleBuild_pre( routine, args )
{
  let o = _.routineOptions( routine, args );
  return o;
}

function moduleBuild_body( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let con = new _.Consequence().take( null );

  let builds = module._buildsResolve
  ({
    name : o.name,
    criterion : o.criterion,
    kind : o.kind,
  });

  // if( logger.verbosity >= 2 && builds.length > 1 )
  // {
  //   logger.up();
  //   logger.log( module.infoExportResource( builds ) );
  //   logger.down();
  // }

  if( builds.length !== 1 )
  throw module.errTooMany( builds, `${o.kind} scenario` );

  let build = builds[ 0 ];
  will._willfilesReadEnd( module );

  let run = new will.BuildRun
  ({
    build,
    recursive : 0,
  });

  return con
  .then( () =>
  {
    _.assert( !module.isOut );
    // debugger;
    return module.modulesUpform({ all : 0, subModulesFormed : 1, peerModulesFormed : 1 });
    // return module.upform({ all : 0, subModulesFormed : 1, peerModulesFormed : 1 });
    // return null;
  })
  .then( () => build.perform({ run }) )
  .then( () =>
  {
    _.assert( !module.peerModule || module.peerModule.isOut );
    // debugger;
    // return module.peerModule.upform({ all : 1, resourcesFormed : 0 });
    return null;
  });
}

moduleBuild_body.defaults =
{
  name : null,
  criterion : null,
  kind : 'export',
}

let moduleBuild = _.routineFromPreAndBody( moduleBuild_pre, moduleBuild_body );
moduleBuild.defaults.kind = 'build';
let moduleExport = _.routineFromPreAndBody( moduleBuild_pre, moduleBuild_body );
moduleExport.defaults.kind = 'export';

// --
// batcher
// --

function modulesEach_pre( routine, args )
{
  let module = this;

  let o = args[ 0 ]
  if( _.routineIs( args[ 0 ] ) )
  o = { onUp : args[ 0 ] };
  o = _.routineOptions( routine, o );
  _.assert( args.length === 0 || args.length === 1 );
  _.assert( _.arrayHas( [ '/', '*/module', '*/relation' ], o.outputFormat ) )

  return o;
}

function modulesEach_body( o )
{
  let module = this;
  let will = module.will;
  let logger = will.logger;
  // let visitedModulesMap = Object.create( null );
  // let visitedModulesArray = [];

  _.assertRoutineOptions( modulesEach, o );

  // var sys = new _.graph.AbstractGraphSystem
  // ({
  //   onNodeNameGet : recordName,
  //   onOutNodesGet : recordSubmodules,
  // });

  // let sys = will.graphSystem;
  // let group = sys.nodesGroup();

  let graph = will.graphSystemMake({ withPeers : o.withPeers });
  let group = graph.nodesGroup();

  // let nodes = [ recordFromModule( module ) ];
  // if( o.withPeers && module.peerModule )
  // nodes.push( recordFromModule( module.peerModule ) );

  let nodes = [ group.nodeFrom( module ) ];
  if( o.withPeers && module.peerModule )
  nodes.push( group.nodeFrom( module.peerModule ) );

  let o2 = _.mapOnly( o, group.each.defaults );
  o2.roots = nodes;
  o2.onUp = handleUp;
  o2.onDown = handleDown;
  let result = group.each( o2 );

  // ({
  //   roots : nodes,
  //   onUp : handleUp,
  //   onDown : handleDown,
  //   recursive : o.recursive,
  //   withStem : o.withStem,
  // });

  if( o.outputFormat !== '/' )
  return result.map( ( record ) => outputFrom( record ) );

  return result;

  /* */

  // function recordName( record )
  // {
  //   return record.module ? record.module.qualifiedName : record.relation.qualifiedName;
  // }
  //
  // /* */
  //
  // function recordSubmodules( record )
  // {
  //   let result = [];
  //   if( record.module )
  //   for( let s in record.module.submoduleMap )
  //   {
  //     let record2 = recordFromRelation( record.module.submoduleMap[ s ] );
  //
  //     if( record2.relation )
  //     record2.opener = record2.relation.opener;
  //     if( record2.opener )
  //     record2.module = record2.opener.openedModule;
  //
  //     result.push( record2 );
  //
  //     if( o.withPeers && record2.module && record2.module.peerModule )
  //     {
  //       result.push( recordFromModule( record2.module.peerModule ) );
  //     }
  //
  //   }
  //   // logger.log( `list ${record.module ? record.module.absoluteName : record.relation.absoluteName} ${result.length}` );
  //   return result;
  // }

  /* */

  function isActual( record )
  {
    if( !o.withOut && record.module )
    if( record.module.isOut )
    return false;

    if( !o.withIn && record.module )
    if( !record.module.isOut )
    return false;

    if( !o.withOptional )
    if( !record.relation || record.relation.isOptional() )
    return false;

    if( !o.withMandatory && record.relation )
    if( !record.relation.isOptional() )
    return false;

    if( !o.withEnabled && record.relation )
    if( record.relation.enabled )
    return false;

    if( !o.withDisabled && record.relation )
    if( !record.relation.enabled )
    return false;

    return true;
  }

  /* */

  function handleUp( record, it )
  {

    it.continueNode = isActual( record );

    if( o.onUp )
    o.onUp.call( module, outputFrom( record ), it );

  }

  function handleDown( record, it )
  {
    if( o.onDown )
    o.onDown.apply( module, outputFrom( record ), it );
  }

  function outputFrom( record )
  {
    if( o.outputFormat === '*/module' )
    return record.module;
    else if( o.outputFormat === '*/relation' )
    return record.relation;
    else
    return record;
  }

  /* */

  // function recordFromRelation( relation )
  // {
  //   let record;
  //
  //   if( relation.opener )
  //   {
  //     record = visitedModulesMap[ relation.opener.commonPath ];
  //   }
  //   else
  //   {
  //     debugger;
  //   }
  //
  //   if( !record )
  //   {
  //     // record = Object.create( null );
  //     // record.relation = null;
  //     // record.opener = null;
  //     // record.module = null;
  //     record = will.graphRecordFrom( relation );
  //     visitedModulesArray.push( record );
  //     if( relation.opener )
  //     visitedModulesMap[ relation.opener.commonPath ] = record;
  //   }
  //   else
  //   {
  //   }
  //
  //   if( relation.opener )
  //   record.opener = relation.opener;
  //
  //   record.relation = relation;
  //   return record;
  // }
  //
  // /* */
  //
  // function recordFromModule( module )
  // {
  //   let record;
  //
  //   record = visitedModulesMap[ module.commonPath ];
  //
  //   if( !record )
  //   {
  //     // record = Object.create( null );
  //     // record.relation = null;
  //     // record.opener = null;
  //     // record.module = null;
  //     record = will.graphRecordFrom( module );
  //     visitedModulesArray.push( record );
  //     visitedModulesMap[ module.commonPath ] = record;
  //   }
  //   else
  //   {
  //   }
  //
  //   _.assert( !record.module || record.module === module );
  //   record.module = module;
  //   return record;
  // }

}

var defaults = modulesEach_body.defaults = _.mapExtend( null, _.graph.AbstractNodesGroup.prototype.each.defaults );

defaults.outputFormat = '*/module'; /* / | * / module | * / relation */
defaults.onUp = null;
defaults.onDown = null;
defaults.recursive = 1;
defaults.withStem = 0;
defaults.withPeers = 0;
defaults.withOut = 1;
defaults.withIn = 1;
defaults.withOptional = 1;
defaults.withMandatory = 1;
defaults.withEnabled = 1;
defaults.withDisabled = 0;

let modulesEach = _.routineFromPreAndBody( modulesEach_pre, modulesEach_body );

//

function modulesEachDo( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let modules;
  let con = new _.Consequence().take( null );

  o = _.routineOptions( modulesEachDo, arguments );

  con.then( () =>
  {
    // debugger;
    if( !o.downloading )
    return null;
    return module.subModulesDownload();
  });

  con.then( () =>
  {
    // debugger;
    return module.upform({ all : 0, subModulesFormed : 1 });
  });

  con.then( () =>
  {
    let o2 = _.mapOnly( o, module.modulesEach.defaults );
    o2.outputFormat = '/';
    modules = module.modulesEach( o2 );
    return modules;
  });

  con.then( () =>
  {
    let con2 = new _.Consequence().take( null );
    for( let m = modules.length-1 ; m >= 0 ; m-- ) ( function( r )
    {
      con2
      .then( () =>
      {
        if( !r.module )
        debugger;
        if( !r.module && o.allowingMissing )
        return null;
        if( !r.module )
        throw _.err
        (
            `Cant ${o.actionName} ${module.absoluteName} because ${r.relation ? r.relation.absoluteName : r.opener.absoluteName} is not available.`
          , `\nLooked at ${r.opener ? r.opener.commonPath : r.relation.path}`
        );
        return o.onEach( r, o );
      })
    })( modules[ m ] );

    return con2;
  });

  return con;
}

var defaults = modulesEachDo.defaults = _.mapExtend( null, modulesEach.defaults );

defaults.recursive = 0;
defaults.withStem = 1;
defaults.withPeers = 1;
defaults.allowingMissing = 0;
defaults.downloading = 0;
defaults.onEach = null;
defaults.actionName = null;

delete defaults.outputFormat;

//

function modulesBuild_pre( routine, args )
{
  let o = _.routineOptions( routine, args );
  return o;
}

function modulesBuild_body( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  o = _.routineOptions( modulesBuild_body, arguments );
  let o2 = _.mapOnly( o, module.modulesEachDo.defaults );
  o2.onEach = handleEach;
  o2.actionName = o.kind;
  return module.modulesEachDo( o2 );

  /* */

  function handleEach( record, op )
  {
    let o3 = _.mapOnly( o, module.moduleBuild.defaults );
    return record.module.moduleBuild( o3 );
  }

}

var defaults = modulesBuild_body.defaults = _.mapExtend( null, moduleBuild.defaults, modulesEach.defaults );

defaults.recursive = 0;
defaults.withStem = 1;
defaults.withPeers = 0;
defaults.withOut = 0;
defaults.withIn = 1;

delete defaults.outputFormat;

let modulesBuild = _.routineFromPreAndBody( modulesBuild_pre, modulesBuild_body );
modulesBuild.defaults.kind = 'build';
let modulesExport = _.routineFromPreAndBody( modulesBuild_pre, modulesBuild_body );
modulesExport.defaults.kind = 'export';

//

function modulesUpform( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  o = _.routineOptions( modulesUpform, arguments );
  let o2 = _.mapOnly( o, module.modulesEachDo.defaults );
  o2.onEach = handleEach;
  o2.actionName = 'upform';
  return module.modulesEachDo( o2 );

  /* */

  function handleEach( record, op )
  {
    let o3 = _.mapOnly( o, module.upform.defaults );
    return record.module.upform( o3 );
  }

}

var defaults = modulesUpform.defaults = _.mapExtend( null, upform.defaults, modulesEach.defaults );

defaults.recursive = 2;
defaults.withStem = 1;
defaults.withPeers = 1;
defaults.downloading = 0;
defaults.allowingMissing = 1;

delete defaults.outputFormat;

// --
// submodule
// --

function rootModuleGet()
{
  let module = this;
  return module[ rootModuleSymbol ];
}

//

function rootModuleSet( src )
{
  let module = this;
  _.assert( src === null || src instanceof _.Will.OpenedModule );
  module[ rootModuleSymbol ] = src;
  return src;
}

//

function superRelationsSet( src )
{
  let module = this;

  _.assert( src === null || _.arrayIs( src ) );
  _.assert( src === null || src.every( ( superRelation ) => superRelation instanceof _.Will.ModulesRelation ) );

  module[ superRelationsSymbol ] = src;

  return src;
}

//

function submodulesAreDownloaded( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let result = Object.create( null );

  o = _.routineOptions( submodulesAreDownloaded, arguments );
  // _.assert( module === module.rootModule );
  _.assert( arguments.length === 0 );

  debugger;
  let o2 = _.mapExtend( null, o );
  o2.outputFormat = '*/relation';
  let relations = module.modulesEach( o2 );
  relations = _.index( relations, '*/commonPath' );
  debugger;

  return _.map( relations, ( relation ) =>
  {
    if( !relation.opener )
    return false;
    _.assert( _.boolLike( relation.opener.isDownloaded ) );
    return relation.opener.isDownloaded;
  });
}

var defaults = submodulesAreDownloaded.defaults = _.mapExtend( null, modulesEach.defaults );

delete defaults.outputFormat;
delete defaults.onUp;
delete defaults.onDown;

//

function submodulesAllAreDownloaded( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let result = Object.create( null );

  o = _.routineOptions( submodulesAllAreDownloaded, arguments );
  // _.assert( module === module.rootModule );
  _.assert( arguments.length === 0 );

  // debugger;
  let o2 = _.mapExtend( null, o );
  o2.outputFormat = '*/relation';
  let relations = module.modulesEach( o2 );
  // debugger;

  return relations.every( ( relation ) =>
  {
    if( !relation.opener )
    return false;
    // debugger;
    _.assert( _.boolLike( relation.opener.isDownloaded ) );
    return relation.opener.isDownloaded;
  });
}

var defaults = submodulesAllAreDownloaded.defaults = _.mapExtend( null, submodulesAreDownloaded.defaults );

//

function submodulesAreValid( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let result = Object.create( null );

  o = _.routineOptions( submodulesAreValid, arguments );
  // _.assert( module === module.rootModule );
  _.assert( arguments.length === 0 );

  let o2 = _.mapExtend( null, o );
  o2.outputFormat = '*/relation';
  let relations = module.modulesEach( o2 );
  relations = _.index( relations, '*/absoluteName' );

  return _.map( relations, ( relation ) =>
  {
    if( !relation.opener )
    return false;
    if( !relation.opener.openedModule )
    return false;
    return relation.opener.openedModule.isValid();
  });

}

var defaults = submodulesAreValid.defaults = _.mapExtend( null, modulesEach.defaults );

delete defaults.outputFormat;
delete defaults.onUp;
delete defaults.onDown;

//

function submodulesAllAreValid( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let result = Object.create( null );

  o = _.routineOptions( submodulesAllAreValid, arguments );
  // _.assert( module === module.rootModule );
  _.assert( arguments.length === 0 );

  let o2 = _.mapExtend( null, o );
  o2.outputFormat = '*/relation';
  let relations = module.modulesEach( o2 );

  return relations.every( ( relation ) =>
  {
    if( !relation.opener )
    return false;
    return relation.opener.isValid();
  });
}

var defaults = submodulesAllAreValid.defaults = _.mapExtend( null, submodulesAreValid.defaults );

//

function submodulesClean()
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  _.assert( module.preformed > 0  );
  _.assert( arguments.length === 0 );

  let result = module.clean
  ({
    cleaningSubmodules : 1,
    cleaningOut : 0,
    cleaningTemp : 0,
  });

  return result;
}

//

function _subModulesDownload_pre( routine, args )
{
  let module = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length <= 2 );

  let o;
  if( args[ 1 ] !== undefined )
  o = { name : args[ 0 ], criterion : args[ 1 ] }
  else
  o = args[ 0 ];

  o = _.routineOptions( routine, o );

  return o;
}

function _subModulesDownload_body( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let downloadedNumber = 0;
  let remoteNumber = 0;
  let totalNumber = _.mapKeys( module.submoduleMap ).length;
  let time = _.timeNow();
  let con = new _.Consequence().take( null );
  let downloadedMap = Object.create( null );

  _.assert( module.preformed > 0  );
  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _subModulesDownload_body, arguments );

  logger.up();

  let o2 = _.mapOnly( o, module.modulesEach );
  o2.outputFormat = '/';
  let modules = module.modulesEach( o2 );
  downloadAgain( modules );

  con.finally( ( err, arg ) =>
  {
    logger.down();
    if( err )
    throw _.err( err, '\nFailed to', ( o.updating ? 'update' : 'download' ), 'submodules of', module.decoratedQualifiedName );
    logger.rbegin({ verbosity : -2 });
    if( o.dry )
    logger.log( ' + ' + downloadedNumber + '/' + totalNumber + ' submodule(s) of ' + module.decoratedQualifiedName + ' will be ' + ( o.updating ? 'updated' : 'downloaded' ) );
    else
    logger.log( ' + ' + downloadedNumber + '/' + totalNumber + ' submodule(s) of ' + module.decoratedQualifiedName + ' were ' + ( o.updating ? 'updated' : 'downloaded' ) + ' in ' + _.timeSpent( time ) );
    logger.rend({ verbosity : -2 });
    return arg;
  });

  return con;

  /* */

  function downloadAgain( modules )
  {
    let remoteNumberWas;

    _.assert( _.arrayIs( modules ) );

    remoteNumberWas = remoteNumber;

    // for( let n in submoduleMap )
    modules.forEach( ( r ) =>
    {
      // let submodule = submoduleMap[ n ];

      _.assert
      (
        !!r.opener,
        () => 'Submodule' + ( r.relation ? r.relation.qualifiedName : r.module.qualifiedName ) + ' was not opened or downloaded'
      );

      // debugger;
      if( r.opener.formed < 2 )
      r.opener.remoteForm();

      _.assert
      (
        !!r.opener && r.opener.formed >= 2,
        () => 'Submodule' + ( r.opener ? r.opener.qualifiedName : n ) + ' was not preformed to download it'
      );

      if( !r.opener.isRemote )
      return;
      if( r.relation && !r.relation.enabled )
      return;

      // debugger;
      con.then( () =>
      {

        if( downloadedMap[ r.opener.remotePath ] )
        return null;

        remoteNumber += 1;

        let o2 = _.mapOnly( o, r.opener._remoteDownload.defaults );
        // let o2 = _.mapExtend( null, o );
        // delete o2.downloadedMap;
        let result = _.Consequence.From( r.opener._remoteDownload( o2 ) );
        return result.then( ( arg ) =>
        {
          _.assert( _.boolIs( arg ) );
          _.assert( _.strIs( r.opener.remotePath ) );
          downloadedMap[ r.opener.remotePath ] = r.opener;

          if( arg )
          downloadedNumber += 1;

          return arg;
        });

      });

    });

  }

  /* */

  // function downloadRecursive()
  // {
  //   let remoteNumberWas;
  //
  //   remoteNumberWas = remoteNumber;
  //
  //   for( let n in module.submoduleMap )
  //   {
  //     let submodule = module.submoduleMap[ n ];
  //
  //     if( !submodule.opener )
  //     {
  //       debugger;
  //       submodule.form();
  //     }
  //
  //   }
  //
  // }

}

var defaults = _subModulesDownload_body.defaults = _.mapExtend( null, modulesEach.defaults );

defaults.withPeers = 0;
defaults.updating = 0;
defaults.dry = 0;

delete defaults.outputFormat;

// {
//   updating : 0,
//   recursive : 0,
//   dry : 0,
//   downloadedMap : null,
// }

let _subModulesDownload = _.routineFromPreAndBody( _subModulesDownload_pre, _subModulesDownload_body );

//

let subModulesDownload = _.routineFromPreAndBody( _subModulesDownload_pre, _subModulesDownload_body, 'subModulesDownload' );
subModulesDownload.defaults.updating = 0;

//

let submodulesUpdate = _.routineFromPreAndBody( _subModulesDownload_pre, _subModulesDownload_body, 'submodulesUpdate' );
submodulesUpdate.defaults.updating = 1;

//

function submodulesFixate( o )
{
  let module = this;
  let will = module.will;
  let logger = will.logger;

  _.assert( module.preformed > 0  );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  o = _.routineOptions( submodulesFixate, arguments );

  let o2 = _.mapExtend( null, o );
  o2.module = module;
  module.moduleFixate( o2 );

  for( let m in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ m ];

    if( !submodule.opener )
    continue;

    let o2 = _.mapExtend( null, o );
    o2.submodule = submodule;
    o2.module = submodule.opener.openedModule;
    module.moduleFixate( o2 );

  }

  return module;
}

submodulesFixate.defaults =
{
  dry : 0,
  upgrading : 0,
  reportingNegative : 0,
}

//

function moduleFixate( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let report = Object.create( null );
  let resolved = Object.create( null );

  if( !_.mapIs( o ) )
  o = { module : o }

  _.routineOptions( moduleFixate, o );
  _.assert( module.preformed > 0  );
  _.assert( arguments.length === 1 );
  _.assert( _.boolLike( o.dry ) );
  _.assert( _.boolLike( o.upgrading ) );
  _.assert( o.module  === null || o.module instanceof will.OpenedModule );
  _.assert( o.submodule === null || o.submodule instanceof will.ModulesRelation );
  // _.assert( o.module  === null || o.module.rootModule === o.module || _.arrayHas( o.module.superRelations, module ) );

  if( o.module )
  superModuleFixate( o.module );

  if( o.submodule )
  submoduleFixate( o.submodule );

  /* */

  if( will.verbosity >= 2 )
  log();

  /* */

  return report;

  /* */

  function superModuleFixate( superModule )
  {
    let remote = superModule.pathResourceMap[ 'remote' ];
    if( remote && remote.path && remote.path.length && remote.willf && superModule.rootModule !== superModule )
    {

      if( _.arrayIs( remote.path ) && remote.path.length === 1 )
      remote.path = remote.path[ 0 ];

      _.assert( _.strIs( remote.path ) );

      let originalPath = remote.path;
      let fixatedPath = resolve( originalPath )

      let o2 = _.mapExtend( null, o );

      o2.replacer = [ 'remote', 'path' ];
      o2.originalPath = originalPath;
      o2.fixatedPath = fixatedPath;
      o2.report = report;

      o2.willfilePath = [ remote.willf.filePath ];
      let secondaryWillfilesPath = remote.module.pathResolve
      ({
        selector : 'path::module.original.willfiles',
        missingAction : 'undefine',
      });

      if( secondaryWillfilesPath )
      _.arrayAppendArraysOnce( o2.willfilePath, secondaryWillfilesPath );

      module.moduleFixateAct( o2 );

      if( !o.dry && fixatedPath )
      {
        superModule.remotePath = fixatedPath;
        _.assert( superModule.remotePath === fixatedPath );
        _.assert( remote.path === fixatedPath );
      }

    }

  }

  /* */

  function submoduleFixate( submodule )
  {

    if( submodule.opener && !submodule.opener.isRemote )
    return;

    let originalPath = submodule.path;
    let fixatedPath = resolve( originalPath )

    let o2 = _.mapExtend( null, o );
    o2.replacer = [ submodule.name, 'path' ];
    o2.originalPath = originalPath;
    o2.fixatedPath = fixatedPath;
    o2.willfilePath = submodule.willf.filePath;
    o2.report = report;

    module.moduleFixateAct( o2 );

    if( !o.dry && fixatedPath )
    {
      submodule.path = fixatedPath;
      if( submodule.opener )
      submodule.opener.remotePath = fixatedPath;
    }

  }

  /* */

  function log()
  {
    let grouped = Object.create( null );
    let result = '';

    debugger;
    if( _.mapKeys( report ).length === 0 )
    return;

    let fixated = o.upgrading ? 'was upgraded' : 'was fixated';
    if( o.dry )
    fixated = o.upgrading ? 'will be upgraded' : 'will be fixated';
    let nfixated = o.upgrading ? 'was not upgraded' : 'was not fixated';
    if( o.dry )
    nfixated = o.upgrading ? 'won\'t be upgraded' : 'won\'t be fixated';
    let skipped = 'was skipped';
    if( o.dry )
    skipped = 'will be skipped';

    let count = _.mapVals( report ).filter( ( r ) => r.performed ).length;
    let absoluteName = o.submodule ? o.submodule.decoratedAbsoluteName : o.module.decoratedAbsoluteName;
    // let absoluteName = o.module ? o.module.decoratedAbsoluteName : o.submodule.decoratedAbsoluteName;

    result += 'Remote paths of ' + absoluteName + ' ' + ( count ? fixated : nfixated ) + ( count ? ' to version' : '' );

    for( let r in report )
    {
      let line = report[ r ];
      let movePath = line.fixatedPath ? path.moveTextualReport( line.fixatedPath, line.originalPath ) : _.color.strFormat( line.originalPath, 'path' );
      if( !grouped[ movePath ] )
      grouped[ movePath ] = []
      grouped[ movePath ].push( line )
    }

    for( let move in grouped )
    {
      result += '\n  ' + move;
      for( let l in grouped[ move ] )
      {
        let line = grouped[ move ][ l ];
        if( line.performed )
        result += '\n   + ' + _.color.strFormat( line.willfilePath, 'path' ) + ' ' + fixated;
        else if( line.skipped )
        result += '\n   ! ' + _.color.strFormat( line.willfilePath, 'path' ) + ' ' + skipped;
        else
        result += '\n   ! ' + _.color.strFormat( line.willfilePath, 'path' ) + ' ' + nfixated;
      }
    }

    logger.log( result );

  }

  /* */

  function resolve( originalPath )
  {
    if( resolved[ originalPath ] )
    return resolved[ originalPath ];
    resolved[ originalPath ] = module.moduleFixatePathFor({ originalPath : originalPath, upgrading : o.upgrading });
    return resolved[ originalPath ];
  }

}

var defaults = moduleFixate.defaults = Object.create( submodulesFixate.defaults );
defaults.submodule = null;
defaults.module = null;

//

function moduleFixateAct( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  if( !_.mapIs( o ) )
  o = { submodule : o }

  _.routineOptions( moduleFixateAct, o );
  _.assert( module.preformed > 0  );
  _.assert( arguments.length === 1 );
  _.assert( _.boolLike( o.dry ) );
  _.assert( _.boolLike( o.upgrading ) );
  _.assert( o.module  === null || o.module instanceof will.OpenedModule );
  _.assert( o.submodule === null || o.submodule instanceof will.ModulesRelation );
  _.assert( _.strIs( o.willfilePath ) || _.strsAreAll( o.willfilePath ) );
  _.assert( _.strIs( o.originalPath ) );
  _.assert( !o.fixatedPath || _.strIs( o.fixatedPath ) );

  o.willfilePath = _.arrayAs( o.willfilePath );
  o.report = o.report || Object.create( null );

  if( !o.fixatedPath )
  {
    if( o.reportingNegative )
    for( let f = 0 ; f < o.willfilePath.length ; f++ )
    {
      let willfilePath = o.willfilePath[ f ];
      let r = o.report[ willfilePath ] = Object.create( null );
      r.fixatedPath = o.fixatedPath;
      r.originalPath = o.originalPath;
      r.willfilePath = willfilePath;
      r.performed = 0;
      r.skipped = 1;
    }
    return 0;
  }

  if( _.arrayIs( o.replacer ) )
  {
    _.assert( o.replacer.length === 2, 'not tested' );
    // let e = '(?:\\s|.)*?';
    let e = '\\s*?.*?\\s*?.*?\\s*?.*?';
    let replacer = '';
    o.replacer = _.regexpsEscape( o.replacer );
    replacer += '(' + o.replacer[ 0 ] + '\\s*?:' + e + ')';
    o.replacer.splice( 0, 1 );
    replacer += '(' + o.replacer.join( '\\s*?:' + e + ')?(' ) + '\\s*:' + e + ')?';
    replacer += '(' + _.regexpEscape( o.originalPath ) + ')';
    o.replacer = new RegExp( replacer, '' );
  }

  _.assert( _.regexpIs( o.replacer ) );

  // if( o.willfilePath )
  for( let f = 0 ; f < o.willfilePath.length ; f++ )
  fileReplace( o.willfilePath[ f ] );

  return _.mapKeys( o.report ).length;

  /* */

  function fileReplace( willfilePath )
  {

    debugger;
    try
    {

      let code = fileProvider.fileRead( willfilePath );

      if( !_.strHas( code, o.originalPath ) )
      {
        throw _.err( 'Willfile', willfilePath, 'does not have path', o.remotePath );
      }

      if( !_.strHas( code, o.replacer ) )
      {
        throw _.err( 'Willfile', willfilePath, 'does not have path', o.originalPath );
      }

      if( !o.dry )
      {
        code = _.strReplaceAll( code, o.replacer, ( match, it ) =>
        {
          it.groups = it.groups.filter( ( e ) => !!e );
          it.groups[ it.groups.length-1 ] = o.fixatedPath;
          return it.groups.join( '' );
        });
        fileProvider.fileWrite( willfilePath, code );
      }

      let r = o.report[ willfilePath ] = Object.create( null );
      r.fixatedPath = o.fixatedPath;
      r.originalPath = o.originalPath;
      r.willfilePath = willfilePath;
      r.performed = 1;
      r.skipped = 0;

      return true;
    }
    catch( err )
    {
      debugger;
      err = _.err( err, '\nFailed to fixated ' + _.color.strFormat( willfilePath, 'path' ) );
      if( o.reportingNegative )
      {
        let r = o.report[ willfilePath ] = Object.create( null );
        r.fixatedPath = o.fixatedPath;
        r.originalPath = o.originalPath;
        r.willfilePath = willfilePath;
        r.performed = 0;
        r.skipped = 0;
        r.err = err;
      }
      // if( !o.dry )
      // throw err;
      if( will.verbosity >= 4 )
      logger.log( _.errOnce( _.errBrief( err ) ) );
      // _.errLogOnce( _.errBrief( err ) );
      // if( will.verbosity >= 2 )
      // o.log += '\n  in ' + _.color.strFormat( willfilePath, 'path' ) + ' was not found';
    }

  }

}

var defaults = moduleFixateAct.defaults = Object.create( moduleFixate.defaults );
defaults.willfilePath = null;
defaults.originalPath = null;
defaults.fixatedPath = null;
defaults.replacer = null;
defaults.report = null;

//

function moduleFixatePathFor( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( module.preformed > 0  );
  _.assert( arguments.length === 1 );
  _.assert( _.boolLike( o.upgrading ) );
  _.routineOptions( moduleFixatePathFor, o );

  if( !o.originalPath )
  return false;

  if( _.arrayIs( o.originalPath ) && o.originalPath.length === 0 )
  return false;

  let vcs = will.vcsFor( o.originalPath );

  if( !vcs )
  return false;

  if( !o.upgrading )
  if( vcs.pathIsFixated( o.originalPath ) )
  return false;

  let fixatedPath = vcs.pathFixate( o.originalPath );

  if( !fixatedPath )
  return false;

  if( fixatedPath === o.originalPath )
  return false;

  return fixatedPath;
}

var defaults = moduleFixatePathFor.defaults = Object.create( null );
defaults.originalPath = null;
defaults.upgrading = null;

//

function submodulesReload()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  return module.ready
  .then( function( arg )
  {
    return module._subModulesForm();
  })
  .split();

}

//

function submodulesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  module.stager.stageStatePausing( 'subModulesFormed', 0 );
  module.stager.tick();

  return module.stager.stageConsequence( 'subModulesFormed' );
}

//

function _subModulesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!module );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  let con = _.Consequence().take( null );

  module._resourcesAllForm( will.ModulesRelation, con );

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw err;
    return arg;
  });

  return con.split();
}

//
//
// function _attachedModulesOpen()
// {
//   let module = this;
//   let will = module.will;
//   let result = null;
//   let openedModule = module instanceof _.Will.ModuleOpener ? module.openedModule : module;
//
//   if( module.rootModule === null || module.rootModule === openedModule )
//   if( module.willfilesArray.length )
//   result = module._attachedModulesOpenFromData
//   ({
//     willfilesArray : module.willfilesArray.slice(),
//     rootModule : openedModule.rootModule,
//   });
//
//   return result;
// }
//
// //
//
// function _attachedModulesOpenFromData( o )
// {
//   let module = this;
//   let will = module.will;
//
//   o = _.routineOptions( _attachedModulesOpenFromData, arguments );
//
//   for( let f = 0 ; f < o.willfilesArray.length ; f++ )
//   {
//     let willfile = o.willfilesArray[ f ];
//     willfile._read();
//
//     for( let modulePath in willfile.structure.module )
//     {
//       let data = willfile.structure.module[ modulePath ];
//       if( data === 'root' )
//       continue;
//       module._attachedModuleOpenFromData
//       ({
//         modulePath : modulePath,
//         data : data,
//         rootModule : o.rootModule,
//         storagePath : willfile.filePath,
//       });
//     }
//
//   }
//
//   return null;
// }
//
// _attachedModulesOpenFromData.defaults =
// {
//   willfilesArray : null,
//   rootModule : null,
// }
//
// //
//
// function _attachedModuleOpenFromData( o )
// {
//   let module = this;
//   let will = module.will;
//   let fileProvider = will.fileProvider;
//   let path = fileProvider.path;
//   let logger = will.logger;
//
//   o = _.routineOptions( _attachedModuleOpenFromData, arguments ); debugger; xxx
//
//   let modulePath = path.join( module.dirPath, o.modulePath );
//   // let willf = will.willfileFor
//   // ({
//   //   // filePath : modulePath + '.will.cached!',
//   //   filePath : modulePath + '.will.yml',
//   //   will : will,
//   //   role : 'single',
//   //   data : o.data,
//   //   storagePath : o.storagePath,
//   // });
//
//   // let opener2 = will.openerMake({ opener : o2 ]);
//
//   // let opener2 = will.ModuleOpener
//   // ({
//   //   will : will,
//   //   willfilesPath : modulePath,
//   //   willfilesArray : [ willf ],
//   //   finding : 0,
//   //   rootModule : o.rootModule,
//   // }).preform();
//
//   opener2.find();
//
//   return opener2.openedModule;
// }
//
// _attachedModuleOpenFromData.defaults =
// {
//   modulePath : null,
//   storagePath : null,
//   data : null,
//   rootModule : null,
// }

// --
// peer
// --

function peerModuleOpen( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  o = _.routineOptions( peerModuleOpen, arguments );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  let con = _.Consequence().take( null );

  con.then( ( arg ) =>
  {
    if( module.peerModule )
    return module.peerModule;
    return open();
  });

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw err;
    return arg;
  });

  return con;

  /* */

  function open()
  {
    let peerWillfilesPath = module.peerWillfilesPathFromWillfiles();

    let o2 =
    {
      willfilesPath : peerWillfilesPath,
      rootModule : module.rootModule,
      peerModule : module,
      searching : 'exact',
    }

    let opener2 = will.openerMake
    ({
      throwing : 0,
      opener : o2,
    })

    return opener2.open({ throwing : 1 })
    .finally( ( err, peerModule ) =>
    {

      peerModule = peerModule || opener2.openedModule || null;
      opener2.openedModule = null;
      opener2.finit();
      _.assert( peerModule === null || peerModule.peerModule === module );

      if( err )
      {
        module.peerModule = null;
        if( peerModule && !peerModule.isUsed() )
        peerModule.finit();
        if( o.throwing )
        throw err;
        else
        _.errAttend( err );
        return null;
      }

      module.peerModule = peerModule;
      return peerModule;
    });
  }

}

peerModuleOpen.defaults =
{
  throwing : 1,
}

//

function _peerModulesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  return module.peerModuleOpen({ throwing : 0 });
}

//

function _peerChanged()
{
  let module = this;
  let will = module.will;

  if( !will )
  return;

  if( module.isOut )
  {
    let originalWillfilesPath = module.originalWillfilesPath;
    module._peerWillfilesPathAssign( originalWillfilesPath );
  }
  else
  {
    let outfilePath = null;
    if( module.about.name )
    outfilePath = module.outfilePathGet();
    module._originalWillfilesPathAssign( null );
    module._peerWillfilesPathAssign( outfilePath );
  }

}

//

function peerModuleSet( src )
{
  let module = this;
  let will = module.will;

  _.assert( src === null || src instanceof _.Will.OpenedModule );

  if( module.peerModule === src )
  return src;

  let was = module.peerModule;
  module[ peerModuleSymbol ] = src;

  if( src )
  {
    let fileProvider = will.fileProvider;
    let path = fileProvider.path;
    if( src.peerModule !== null && src.peerModule !== module )
    throw _.err
    (
        'Inconsisteny in path to peer module'
      + `\n  ${path.moveTextualReport( module.commonPath, module.peerWillfilesPath )}`
      + `\n  ${path.moveTextualReport( src.commonPath, src.peerWillfilesPath )}`
      // + `\n  ${module.commonPath} has peer path : ${module.peerWillfilesPath}`
      // + `\n  but`
      // + `\n  ${src.commonPath} has peer path : ${src.peerWillfilesPath}`
    );
    src.peerModule = module;
  }
  else if( was )
  {
    was.peerModule = null;
  }

  _.assert( module.peerModule === null || module.peerModule.peerModule === module );

  return src;
}

//

function peerWillfilesPathFromWillfiles( willfilesArray )
{
  let module = this;
  let will = module.will;

  willfilesArray = willfilesArray || module.willfilesArray;
  willfilesArray = _.arrayAs( willfilesArray );

  let peerWillfilesPath = module.willfilesArray.map( ( willf ) =>
  {
    _.assert( willf instanceof _.Will.Willfile );
    return willf.peerWillfilesPathGet();
  });

  peerWillfilesPath = _.longOnce( _.arrayFlatten( peerWillfilesPath ) );

  return peerWillfilesPath;
}

//

function submodulesPeersOpen_body( o )
{
  let module = this;
  let will = module.will;
  let ready = new _.Consequence().take( null );

  let o2 = _.mapExtend( null, o );
  delete o2.throwing;
  let submodules = module.modulesEach.body.call( module, o2 );

  submodules.forEach( ( submodule ) =>
  {
    ready.then( () => submodule.peerModuleOpen({ throwing : o.throwing }) );
  });

  return ready;
}

var defaults = submodulesPeersOpen_body.defaults = _.mapExtend( null, modulesEach.body.defaults );

defaults.throwing = 1;

let submodulesPeersOpen = _.routineFromPreAndBody( modulesEach_pre, submodulesPeersOpen_body );

// --
// remote
// --

function _remoteChanged()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( !!module.pathResourceMap[ 'current.remote' ] );

  // logger.log( module.absoluteName, '_remoteChanged' ); debugger;

  /* */

  // if( module.isDownloaded && module.remotePath )
  if( module.remotePath )
  {
    let remoteProvider = fileProvider.providerForPath( module.remotePath );
    _.assert( !!remoteProvider.isVcs );
    let version = remoteProvider.versionLocalRetrive( module.localPath );
    if( version )
    {
      let remotePath = _.uri.parseConsecutive( module.remotePath );
      remotePath.hash = version;
      module.pathResourceMap[ 'current.remote' ].path = _.uri.str( remotePath );
    }
  }
  else
  {
    module.pathResourceMap[ 'current.remote' ].path = null;
  }

}

//

// function remoteIsDownloadedChanged()
// {
//   let module = this;
//   let will = module.will;
//   let fileProvider = will.fileProvider;
//   let path = fileProvider.path;
//
//   _.assert( !!module.pathResourceMap[ 'current.remote' ] );
//
//   /* */
//
//   if( module.isDownloaded && module.remotePath )
//   {
//
//     let remoteProvider = fileProvider.providerForPath( module.remotePath );
//     _.assert( !!remoteProvider.isVcs );
//
//     let version = remoteProvider.versionLocalRetrive( module.localPath );
//     if( version )
//     {
//       let remotePath = _.uri.parseConsecutive( module.remotePath );
//       remotePath.hash = version;
//       module.pathResourceMap[ 'current.remote' ].path = _.uri.str( remotePath );
//     }
//   }
//   else
//   {
//     module.pathResourceMap[ 'current.remote' ].path = null;
//   }
//
// }
//
// //
//
// function remoteIsDownloadedSet( src )
// {
//   let module = this;
//
//   _.assert( _.boolLike( src ) );
//
//   if( src !== null )
//   src = !!src;
//
//   let changed = module[ isDownloadedSymbol ] !== undefined && module[ isDownloadedSymbol ] !== src;
//
//   module[ isDownloadedSymbol ] = src;
//
//   if( changed )
//   module.remoteIsDownloadedChanged();
//
// }

// --
// resource
// --

function resourcesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );

  module.stager.stageStatePausing( 'resourcesFormed', 0 );
  module.stager.tick();

  return module.stager.stageConsequence( 'resourcesFormed' );
}

//

function _resourcesForm()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let con = new _.Consequence().take( null );

  if( module.submodulesAllAreDownloaded() && module.submodulesAllAreValid() )
  {

    con.then( () => module._resourcesFormAct() );

    con.then( ( arg ) =>
    {
      return arg;
    });

  }
  else
  {
    if( will.verbosity === 2 ) /* xxx : throw error instead? */
    logger.error( ' ! One or several submodules of ' + module.decoratedQualifiedName + ' were not downloaded!'  );
  }

  return con;
}

//

function _resourcesFormAct()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 0 );
  _.assert( !!module );
  _.assert( !!will );
  _.assert( !!fileProvider );
  _.assert( !!logger );
  _.assert( !!will.formed );
  _.assert( !!module.preformed );

  let con = _.Consequence().take( null );

  /* */

  module._resourcesAllForm( will.ModulesRelation, con );
  module._resourcesAllForm( will.Exported, con );
  module._resourcesAllForm( will.PathResource, con );
  module._resourcesAllForm( will.Reflector, con );
  module._resourcesAllForm( will.Step, con );
  module._resourcesAllForm( will.Build, con );

  /* */

  con.finally( ( err, arg ) =>
  {
    if( err )
    throw err;
    return arg;
  });

  return con.split();
}

//

function _resourcesAllForm( Resource, con )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( _.constructorIs( Resource ) );
  _.assert( arguments.length === 2 );

  for( let s in module[ Resource.MapName ] )
  {
    let resource = module[ Resource.MapName ][ s ];
    _.assert( !!resource.formed );
    con.then( ( arg ) => resource.form2() );
  }

  for( let s in module[ Resource.MapName ] )
  {
    let resource = module[ Resource.MapName ][ s ];
    con.then( ( arg ) => resource.form3() );
  }

}

//

function resourceClassForKind( resourceKind )
{
  let module = this;
  let will = module.will;
  let result = will[ will.ResourceKindToClassName.forKey( resourceKind ) ];

  _.assert( arguments.length === 1 );
  _.sure( _.routineIs( result ), () => 'Cant find class for resource kind ' + _.strQuote( resourceKind ) );

  return result;
}

//

function resourceMapForKind( resourceKind )
{
  let module = this;
  let will = module.will;
  let result;

  _.assert( module.rootModule instanceof will.OpenedModule );

  // logger.log( 'resourceMapForKind', resourceKind );
  // if( resourceKind === 'submodule' )
  // {
  //   let valid = module.submodulesAreValid();
  //   if( !_.all( valid ) )
  //   throw _.errBrief
  //   (
  //       `Cant do select in non-valid submodules.`
  //     , `\nOne or several submodules of ${module.absoluteName} are not opened or invalid :`
  //     , '\n  ' + _.mapKeys( _.but( valid ) ).join( '\n  ' )
  //   );
  // }

  if( resourceKind === 'export' )
  result = module.buildMap;
  else if( resourceKind === 'about' )
  result = module.about.structureExport();
  else if( resourceKind === 'module' )
  result = module.rootModule.moduleWithNameMap;
  else
  result = module[ will.ResourceKindToMapName.forKey( resourceKind ) ];

  _.assert( arguments.length === 1 );
  _.sure( _.objectIs( result ), () => 'Cant find resource map for resource kind ' + _.strQuote( resourceKind ) );

  return result;
}

//

function resourceMaps()
{
  let module = this;
  let will = module.will;

  let ResourcesNames =
  [
    'module',
    'submodule',
    'path',
    'reflector',
    'step',
    'build',
    'exported',
  ]

  let resources =
  {
    'module' : module.resourceMapForKind( 'module' ),
    'submodule' : module.resourceMapForKind( 'submodule' ),
    'path' : module.resourceMapForKind( 'path' ),
    'reflector' : module.resourceMapForKind( 'reflector' ),
    'step' : module.resourceMapForKind( 'step' ),
    'build' : module.resourceMapForKind( 'build' ),
    'exported' : module.resourceMapForKind( 'exported' ),
  }

  return resources;
}

//

function resourceMapsForKind( resourceSelector )
{
  let module = this;
  let will = module.will;

  if( !_.path.isGlob( resourceSelector ) )
  return module.resourceMapForKind( resourceSelector );

  let resources = module.resourceMaps();
  let result = _.path.globFilterKeys( resources, resourceSelector );
  return result;
}

//

function resourceGet( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceKind ) );
  _.assert( _.strIs( resourceName ) );

  let map = module.resourceMapForKind( resourceKind );

  return map[ resourceName ];
}

//

function resourceObtain( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceName ) );

  let resourceMap = module.resourceMapForKind( resourceKind );

  _.sure( !!resourceMap, 'No resource map of kind' + resourceKind );

  let resource = resourceMap[ resourceName ];

  if( !resource )
  resource = module.resourceAllocate( resourceKind, resourceName );

  _.assert( resource instanceof will.Resource );
  if( resource instanceof will.PathResource )
  _.assert( module.pathResourceMap[ resource.name ] === resource );

  return resource;
}

//

function resourceAllocate( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceName ) );

  let resourceName2 = module.resourceNameAllocate( resourceKind, resourceName );
  let cls = module.resourceClassForKind( resourceKind );
  let resource = new cls({ module : module, name : resourceName2 }).form1();

  return resource;
}

//

function resourceNameAllocate( resourceKind, resourceName )
{
  let module = this;
  let will = module.will;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( resourceKind ) );
  _.assert( _.strIs( resourceName ) );

  let map = module.resourceMapForKind( resourceKind );

  if( map[ resourceName ] === undefined )
  return resourceName;

  let counter = 1;
  let resourceName2;

  let ends = /\.\d+$/;
  if( ends.test( resourceName ) )
  resourceName = resourceName.replace( ends, '' );

  do
  {
    resourceName2 = resourceName + '.' + counter;
    counter += 1;
  }
  while( map[ resourceName2 ] !== undefined );

  return resourceName2;
}

// --
// path
// --

function pathsRelative( basePath, filePath )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  if( _.mapIs( filePath ) )
  {
    for( let f in filePath )
    filePath[ f ] = module.pathsRelative( basePath, filePath[ f ] );
    return filePath;
  }

  _.assert( path.isAbsolute( basePath ) );

  if( !filePath )
  return filePath;

  if( !path.s.anyAreAbsolute( filePath ) )
  return filePath;

  filePath = path.filter( filePath, ( filePath ) =>
  {
    if( filePath )
    if( path.isAbsolute( filePath ) )
    return path.s.relative( basePath, filePath );
    return filePath;
  });

  return filePath;
}

//

function pathsRebase( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let Resolver = will.Resolver;

  o = _.routineOptions( pathsRebase, arguments );
  _.assert( path.isAbsolute( o.inPath ) );

  let inPathResource = module.resourceObtain( 'path', 'in' );
  if( inPathResource.path === null )
  inPathResource.path = '.';

  let localPathResource = module.resourceObtain( 'path', 'local' );
  // if( localPathResource.path === null )
  localPathResource.path = '.'; /* xxx : warkaround */

  let inPath = path.canonize( o.inPath );
  let exInPath = module.inPath;
  let relative = path.relative( inPath, exInPath );

  if( inPath === exInPath )
  return;

  /* path */

  for( let p in module.pathResourceMap )
  {
    let resource = module.pathResourceMap[ p ];

    if( p === 'in' )
    continue;
    if( p === 'module.dir' )
    continue;
    if( p === 'local' )
    continue;

    resource.pathsRebase
    ({
      relative : relative,
      exInPath : exInPath,
      inPath : inPath,
    });

  }

  module.inPath = inPath;

  _.assert( module.pathResourceMap[ inPathResource.name ] === inPathResource );
  _.assert( module.inPath === inPath );
  _.assert( path.isRelative( module.pathResourceMap.in.path ) );

  /* submodule */

  for( let p in module.submoduleMap )
  {
    let resource = module.submoduleMap[ p ];

    resource.pathsRebase
    ({
      relative : relative,
      exInPath : exInPath,
      inPath : inPath,
    });

  }

  /* reflector */

  for( let r in module.reflectorMap )
  {
    let resource = module.reflectorMap[ r ];

    resource.pathsRebase
    ({
      relative : relative,
      exInPath : exInPath,
      inPath : inPath,
    });

  }

}

pathsRebase.defaults =
{
  inPath : null,
}

//

function _filePathChange( willfilesPath )
{

  if( !this.will )
  return willfilesPath;

  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;

  _.assert( arguments.length === 1 );

  if( module.willfilesPath )
  will.modulePathUnregister( module );

  let r = Parent.prototype._filePathChange.call( module, willfilesPath );

  module._dirPathAssign( r.dirPath );

  if( r.willfilesPath !== null )
  {
    module._commonPathAssign( r.commonPath );
    _.assert( module.commonPath === r.commonPath );
  }

  module._peerChanged();

  if( module.willfilesPath )
  will.modulePathRegister( module );

  return r.willfilesPath;
}

// //
//
// function _filePathChanged()
// {
//   let module = this;
//
//   _.assert( arguments.length === 0 );
//
//   module._filePathChange( module.willfilesPath );
//
// }

//

function inPathGet()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let result = path.s.join( module.dirPath, ( module.pathMap.in || '.' ) );

  // if( result && _.strHas( result, '//' ) )
  // debugger;

  return result;
}

//

function outPathGet()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  return path.s.join( module.dirPath, ( module.pathMap.in || '.' ), ( module.pathMap.out || '.' ) );
}

//

function outfilePathGet()
{
  let module = this;
  let will = module.will;
  _.assert( arguments.length === 0 );
  return module.OutfilePathFor( module.outPath, module.about.name );
}

//

function cloneDirPathGet( rootModule )
{
  let module = this;
  let will = module.will;
  rootModule = rootModule || module.rootModule;
  let inPath = rootModule.inPath;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return module.CloneDirPathFor( inPath );
}

//

function predefinedPathGet_functor( fieldName, resourceName, absolutize )
{

  return function predefinedPathGet()
  {
    let module = this;

    if( !module.will)
    return null;

    let result = module.pathMap[ resourceName ] || null;

    if( absolutize && result )
    {
      let will = module.will;
      let fileProvider = will.fileProvider;
      let path = fileProvider.path;
      result = path.join( module.inPath, result );
    }

    return result;
  }

}

//

function predefinedPathAssign_functor( fieldName, resourceName, relativizing )
{

  // if( forwarding === undefined )
  // forwarding = true;
  // forwarding = !!forwarding;

  return function predefinedPathAssign( filePath )
  {
    let module = this;

    if( !module.will && !filePath )
    return filePath;

    filePath = _.entityMake( filePath );

    if( !module.pathResourceMap[ resourceName ] )
    {
      let resource = new _.Will.PathResource({ module : module, name : resourceName }).form1();
      resource.criterion = resource.criterion || Object.create( null );
      resource.criterion.predefined = 1;
      resource.writable = 0;
    }

    _.assert( !!module.pathResourceMap[ resourceName ] );

    if( relativizing )
    {
      let basePath = module[ relativizing ];
      _.assert( basePath === null || _.strIs( basePath ) );

      if( filePath && basePath )
      filePath = module.pathsRelative( basePath, filePath );

    }

    if( fieldName === 'willfilesPath' )
    filePath = module._filePathChange( filePath );
    module.pathResourceMap[ resourceName ].path = filePath;

    return filePath;
  }

}

//

function decoratedPathGet_functor( fieldName )
{

  return function decoratedPathGet()
  {
    let module = this;
    let result = module[ fieldName ];
    if( result !== null )
    {
      let will = module.will;
      let fileProvider = will.fileProvider;
      let path = fileProvider.path;
      _.assert( _.strIs( result ) || _.arrayIs( result ) )
      result = path.filter( result, ( p ) => _.color.strFormat( p, 'path' ) );
    }
    return result;
  }

}

//

function predefinedPathSet_functor( fieldName, resourceName )
{

  let assignMethodName = '_' + fieldName + 'Assign';
  _.assert( arguments.length === 2 );

  return function predefinedPathSet( filePath )
  {
    let module = this;

    module[ assignMethodName ]( filePath );
    module._filePathChanged();

    if( resourceName === 'remote' && filePath !== null )
    module._remoteChanged();

    return filePath;
  }

}

//

let willfilesPathGet = predefinedPathGet_functor( 'willfilesPath', 'module.willfiles' );
let dirPathGet = predefinedPathGet_functor( 'dirPath', 'module.dir' );
let commonPathGet = predefinedPathGet_functor( 'commonPath', 'module.common' );
let localPathGet = predefinedPathGet_functor( 'localPath', 'local', 1 );
let remotePathGet = predefinedPathGet_functor( 'remotePath', 'remote' );
let currentRemotePathGet = predefinedPathGet_functor( 'currentRemotePath', 'current.remote' );
let willPathGet = predefinedPathGet_functor( 'willPath', 'will' );
let originalWillfilesPathGet = predefinedPathGet_functor( 'originalWillfilesPath', 'module.original.willfiles' );
let peerWillfilesPathGet = predefinedPathGet_functor( 'peerWillfilesPath', 'module.peer.willfiles' );

let decoratedWillfilesPathGet = decoratedPathGet_functor( 'willfilesPath' );
let decoratedInPathGet = decoratedPathGet_functor( 'inPath' );
let decoratedOutPathGet = decoratedPathGet_functor( 'outPath' );
let decoratedDirPathGet = decoratedPathGet_functor( 'dirPath' );
let decoratedCommonPathGet = decoratedPathGet_functor( 'commonPath' );
let decoratedLocalPathGet = decoratedPathGet_functor( 'localPath' );
let decoratedRemotePathGet = decoratedPathGet_functor( 'remotePath' );
let decoratedCurrentRemotePathGet = decoratedPathGet_functor( 'currentRemotePath' );
let decoratedWillPathGet = decoratedPathGet_functor( 'willPath' );
let decoratedOriginalWillfilesPathGet = decoratedPathGet_functor( 'originalWillfilesPath' );
let decoratedPeerWillfilesPathGet = decoratedPathGet_functor( 'peerWillfilesPath' );

let _inPathAssign = predefinedPathAssign_functor( 'inPath', 'in', 'dirPath', 0 );
let _outPathAssign = predefinedPathAssign_functor( 'outPath', 'out', 'inPath', 0 );
let _willfilesPathAssign = predefinedPathAssign_functor( 'willfilesPath', 'module.willfiles', 0 );
let _dirPathAssign = predefinedPathAssign_functor( 'dirPath', 'module.dir', 0 );
let _commonPathAssign = predefinedPathAssign_functor( 'commonPath', 'module.common', 0 );
let _localPathAssign = predefinedPathAssign_functor( 'localPath', 'local', 0 );
let _remotePathAssign = predefinedPathAssign_functor( 'remotePath', 'remote', 0 );
let _originalWillfilesPathAssign = predefinedPathAssign_functor( 'originalWillfilesPath', 'module.original.willfiles', 0 );
let _peerWillfilesPathAssign = predefinedPathAssign_functor( 'peerWillfilesPath', 'module.peer.willfiles', 0 );

let inPathSet = predefinedPathSet_functor( 'inPath', 'in' );
let outPathSet = predefinedPathSet_functor( 'outPath', 'out' );
let willfilesPathSet = predefinedPathSet_functor( 'willfilesPath', 'module.willfiles' );
let localPathSet = predefinedPathSet_functor( 'localPath', 'local' );
let remotePathSet = predefinedPathSet_functor( 'remotePath', 'remote' );

// --
// name
// --

function nameGet()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let name = null;

  if( !name && module.about )
  name = module.about.name;

  if( !name && module.fileName )
  name = module.fileName;

  // let aliasNames = module.aliasNames;
  // if( aliasNames && aliasNames.length )
  // name = aliasNames[ 0 ];

  if( !name && module.commonPath )
  name = path.fullName( module.commonPath );

  return name;
}

//

function _nameChanged()
{
  let module = this;
  let will = module.will;

  if( !will )
  return;

  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let name = null;
  let rootModule = module.rootModule;

  /* */

  let _originalWillfilesPathAssign = predefinedPathAssign_functor( 'originalWillfilesPath', 'module.original.willfiles', 0 );
  let _peerWillfilesPathAssign = predefinedPathAssign_functor( 'peerWillfilesPath', 'module.peer.willfiles', 0 );

  module._nameUnregister();
  module._nameRegister();
  module._peerChanged();

}

//

function _nameUnregister()
{
  let module = this;
  let will = module.will;
  let rootModule = module.rootModule;

  /* remove from root */

  if( rootModule )
  for( let m in rootModule.moduleWithNameMap )
  {
    if( rootModule.moduleWithNameMap[ m ] === module )
    delete rootModule.moduleWithNameMap[ m ];
  }

  /* remove from system */

  for( let m in will.moduleWithNameMap )
  {
    if( will.moduleWithNameMap[ m ] === module )
    delete will.moduleWithNameMap[ m ];
  }

}

//

function _nameRegister()
{
  let module = this;
  let will = module.will;

  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let name = null;
  let rootModule = module.rootModule;
  let c = 0;

  let aliasNames = module.aliasNames;
  if( aliasNames )
  for( let n = 0 ; n < aliasNames.length ; n++ )
  {
    let name = aliasNames[ n ];

    if( rootModule )
    if( !rootModule.moduleWithNameMap[ name ] )
    {
      c += 1;
      rootModule.moduleWithNameMap[ name ] = module;
    }

    if( !will.moduleWithNameMap[ name ] )
    {
      c += 1;
      will.moduleWithNameMap[ name ] = module;
    }

  }

  // if( module.aliasName )
  // if( !rootModule.moduleWithNameMap[ module.aliasName ] )
  // {
  //   c += 1;
  //   rootModule.moduleWithNameMap[ module.aliasName ] = module;
  // }
  //
  // if( module.fileName )
  // if( !rootModule.moduleWithNameMap[ module.fileName ] )
  // {
  //   c += 1;
  //   rootModule.moduleWithNameMap[ module.fileName ] = module;
  // }

  if( module.about && module.about.name )
  {

    if( rootModule )
    if( !rootModule.moduleWithNameMap[ module.about.name ] )
    {
      c += 1;
      rootModule.moduleWithNameMap[ module.about.name ] = module;
    }

    if( !will.moduleWithNameMap[ module.about.name ] )
    {
      c += 1;
      will.moduleWithNameMap[ module.about.name ] = module;
    }

  }

  return c;
}

//

function aliasNamesGet()
{
  let module = this;
  let will = module.will;
  let result = [];

  if( module.fileName )
  _.arrayAppendElementOnce( result, module.fileName )

  for( let u = 0 ; u < module.userArray.length ; u++ )
  {
    let opener = module.userArray[ u ];
    _.assert( opener instanceof will.ModuleOpener );
    if( opener.aliasName )
    _.arrayAppendElementOnce( result, opener.aliasName )
  }

  return result;
}

//

function absoluteNameGet()
{
  let module = this;
  let rootModule = module.rootModule;
  if( rootModule && rootModule !== module )
  {
    if( rootModule === module.original )
    return rootModule.qualifiedName + ' / ' + 'f::duplicate';
    else
    return rootModule.qualifiedName + ' / ' + module.qualifiedName;
  }
  else
  return module.qualifiedName;
}

//

function shortNameArrayGet()
{
  let module = this;
  let rootModule = module.rootModule;
  if( rootModule === module )
  return [ module.name ];
  let result = rootModule.shortNameArrayGet();
  result.push( module.name );
  return result;
}

// --
// clean
// --

function cleanWhatSingle( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let exps = module.exportsResolve();
  let filePaths = [];

  o = _.routineOptions( cleanWhatSingle, arguments );

  if( o.result === null )
  o.result = Object.create( null );
  o.result[ '/' ] = o.result[ '/' ] || [];

  /* submodules */

  if( o.cleaningSubmodules )
  {

    // debugger;
    find( module.cloneDirPathGet() );
    if( module.rootModule !== module )
    find( module.cloneDirPathGet( module ) );

  }

  /* out */

  if( o.cleaningOut )
  {
    let files = [];

    if( module.about.name )
    {
      let outFilePath = module.outfilePathGet();
      _.arrayAppendArrayOnce( files, [ outFilePath ] );
    }
    for( let e = 0 ; e < exps.length ; e++ )
    {
      let exp = exps[ e ];
      let archiveFilePath = exp.archiveFilePathFor();
      _.arrayAppendArrayOnce( files, [ archiveFilePath ] );
    }

    find( files );
  }

  /* temp dir */

  if( o.cleaningTemp )
  {
    // debugger;
    let resource = module.pathOrReflectorResolve( 'temp' );

    if( resource && resource instanceof _.Will.Reflector )
    {
      debugger;
      let o2 = temp.optionsForFindExport();
      find( o2 );
    }
    else if( resource && resource instanceof _.Will.PathResource )
    {
      // debugger;
      let filePath = resource.path;
      if( !filePath )
      filePath = [];
      filePath = _.arrayAs( path.s.join( module.inPath, filePath ) );
      find( filePath );
    }

    // let temp;
    //
    // temp = module.reflectorResolve
    // ({
    //   selector : 'reflector::temp',
    //   pathResolving : 'in',
    //   missingAction : 'undefine',
    // });
    //
    // if( temp )
    // {
    //   let o2 = temp.optionsForFindExport();
    //   find( o2 );
    // }
    //
    // if( !temp )
    // {
    //   temp = module.pathResolve
    //   ({
    //     selector : 'path::temp',
    //     pathResolving : 'in',
    //     missingAction : 'undefine',
    //   });
    //
    //   if( !temp )
    //   temp = [];
    //
    //   temp = _.arrayAs( path.s.join( module.inPath, temp ) );
    //
    //   for( let p = 0 ; p < temp.length ; p++ )
    //   {
    //     let filePath = temp[ p ];
    //     find( filePath );
    //   }
    //
    // }

  }

  filePaths.sort();

  return o.result;

  /* - */

  function find( op )
  {

    if( _.arrayIs( op ) || _.strIs( op ) )
    op = { filter : { filePath : op } }

    if( _.arrayIs( op.filter.filePath.length ) && !op.filter.filePath.length )
    return;

    let def =
    {
      verbosity : 0,
      allowingMissed : 1,
      withDirs : 1,
      withTerminals : 1,
      maskPreset : 0,
      outputFormat : 'absolute',
      writing : 0,
      deletingEmptyDirs : 1,
      visitingCertain : !o.fast,
    }

    _.mapSupplement( op, def );

    op.filter = op.filter || Object.create( null );
    op.filter.recursive = 2;

    let found = fileProvider.filesDelete( op );
    _.assert( op.filter.formed === 5 );

    let r = path.group
    ({
      keys : op.filter.filePath,
      vals : found,
      result : o.result,
    });

  }

}

cleanWhatSingle.defaults =
{
  cleaningSubmodules : 1,
  cleaningOut : 1,
  cleaningTemp : 1,
  fast : 0,
  result : null,
}

//

function cleanWhat( o )
{
  let module = this;
  let will = module.will;
  let logger = will.logger;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.routineOptions( cleanWhat, arguments );

  if( o.result === null )
  o.result = Object.create( null );
  o.result[ '/' ] = o.result[ '/' ] || [];

  let submodules = module.modulesEach
  ({
    recursive : o.recursive,
    withStem : 1,
  });

  submodules.forEach( ( submodule ) =>
  {
    let o2 = _.mapExtend( null, o );
    delete o2.recursive;
    submodule.cleanWhatSingle( o2 );
  });

  return o.result;
}

var defaults = cleanWhat.defaults = Object.create( cleanWhatSingle.defaults );

defaults.recursive = 0;

//

function cleanWhatReport( o )
{
  let module = this;
  let will = module.will;
  let logger = will.logger;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let time = _.timeNow();

  o = _.routineOptions( cleanWhatReport, arguments );

  if( !o.report )
  {
    let o2 = _.mapExtend( null, o );
    delete o2.report;
    delete o2.explanation;
    delete o2.spentTime;
    o.report = module.cleanWhat( o2 );
  }

  if( !o.spentTime )
  o.spentTime = _.timeNow() - time;

  let textualReport = path.groupTextualReport
  ({
    explanation : o.explanation,
    groupsMap : o.report,
    verbosity : logger.verbosity,
    spentTime : o.spentTime,
  });

  logger.log( textualReport );

  return textualReport;
}

cleanWhatReport.defaults = Object.create( cleanWhat.defaults );
// cleanWhatReport.defaults = Object.create( null );

cleanWhatReport.defaults.report = null;
cleanWhatReport.defaults.explanation = ' . Clean will delete ';
cleanWhatReport.defaults.spentTime = null

//

function clean( o )
{
  let module = this;
  let will = module.will;
  let logger = will.logger;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let time = _.timeNow();

  o = _.routineOptions( clean, arguments );

  let o2 = _.mapExtend( null, o );
  delete o2.late;

  let report = module.cleanWhat( o2 );

  _.assert( _.mapIs( report ) );
  _.assert( _.arrayIs( report[ '/' ] ) );

  for( let f = report[ '/' ].length-1 ; f >= 0 ; f-- )
  {
    let filePath = report[ '/' ][ f ];
    _.assert( path.isAbsolute( filePath ) );

    if( o.fast )
    fileProvider.filesDelete
    ({
      filePath : filePath,
      verbosity : 0,
      throwing : 0,
      late : 1,
    });
    else
    fileProvider.fileDelete
    ({
      filePath : filePath,
      verbosity : 0,
      throwing : 0,
    });

  }

  time = _.timeNow() - time;

  let o3 = _.mapExtend( null, o );
  o3.explanation = ' - Clean deleted ';
  o3.spentTime = time;
  o3.report = report;

  let textualReport = module.cleanWhatReport( o3 );

  return report;
}

var defaults = clean.defaults = Object.create( cleanWhat.defaults );

// --
// resolver
// --

function resolve_pre( routine, args )
{
  let module = this;
  let o = args[ 0 ];

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { selector : o }

  _.routineOptions( routine, o );

  if( o.visited === null )
  o.visited = [];

  o.baseModule = module;

  _.Will.Resolver.resolve.pre.call( _.Will.Resolver, routine, [ o ] );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  // _.assert( _.arrayHas( [ null, 0, false, 'in', 'out' ], o.pathResolving ), 'Unknown value of option path resolving', o.pathResolving );
  // _.assert( _.arrayHas( [ 'undefine', 'throw', 'error' ], o.missingAction ), 'Unknown value of option missing action', o.missingAction );
  // _.assert( _.arrayHas( [ 'default', 'resolved', 'throw', 'error' ], o.prefixlessAction ), 'Unknown value of option prefixless action', o.prefixlessAction );
  _.assert( _.arrayIs( o.visited ) );
  // _.assert( !o.defaultResourceKind || !_.path.isGlob( o.defaultResourceKind ), 'Expects non glob {-defaultResourceKind-}' );

  return o;
}

//

function resolve_body( o )
{
  let module = this;
  let will = module.will;
  _.assert( o.baseModule === module );
  let result = will.Resolver.resolve.body.call( will.Resolver, o );
  return result;
}

_.routineExtend( resolve_body, _.Will.Resolver.resolve );

let resolve = _.routineFromPreAndBody( resolve_pre, resolve_body );

//

let resolveMaybe = _.routineFromPreAndBody( resolve_pre, resolve_body );

_.routineExtend( resolveMaybe, _.Will.Resolver.resolveMaybe );

//

let resolveRaw = _.routineFromPreAndBody( resolve_pre, resolve_body );

_.routineExtend( resolveRaw, _.Will.Resolver.resolveRaw );

//

let pathResolve = _.routineFromPreAndBody( resolve_pre, resolve_body );

_.routineExtend( pathResolve, _.Will.Resolver.pathResolve );

//

// function pathOrReflectorResolve( o )
// {
//   let module = this;
//   let will = module.will;
//   let resource;
//
//   if( _.strIs( o ) )
//   o = { selector : arguments[ 0 ] }
//   _.assert( _.strIs( o.selector ) );
//   _.routineOptions( pathOrReflectorResolve, o );
//
//   resource = module.reflectorResolve
//   ({
//     selector : 'reflector::' + o.selector,
//     pathResolving : 'in',
//     missingAction : 'undefine',
//   });
//
//   if( reflector )
//   return reflector;
//
//   resource = module.pathResolve
//   ({
//     selector : 'path::' + o.selector,
//     pathResolving : 'in',
//     missingAction : 'undefine',
//     pathUnwrapping : 0,
//   });
//
//   return resource;
// }
//
// pathOrReflectorResolve.defaults =
// {
//   selector : null,
// }

function pathOrReflectorResolve_body( o )
{
  let module = this;
  let will = module.will;
  _.assert( o.baseModule === module );
  _.assert( arguments.length === 1 );
  let result = will.Resolver.pathOrReflectorResolve.body.call( will.Resolver, o );
  return result;
}

_.routineExtend( pathOrReflectorResolve_body, _.Will.Resolver.pathOrReflectorResolve );

let pathOrReflectorResolve = _.routineFromPreAndBody( resolve_pre, pathOrReflectorResolve_body );

//

function filesFromResource_pre( routine, args )
{
  let module = this;
  let o = args[ 0 ];

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { selector : o }

  _.routineOptions( routine, o );

  if( o.visited === null )
  o.visited = [];

  o.baseModule = module;

  _.Will.Resolver.filesFromResource.pre.call( _.Will.Resolver, routine, [ o ] );

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  // _.assert( _.arrayHas( [ null, 0, false, 'in', 'out' ], o.pathResolving ), 'Unknown value of option path resolving', o.pathResolving );
  // _.assert( _.arrayHas( [ 'undefine', 'throw', 'error' ], o.missingAction ), 'Unknown value of option missing action', o.missingAction );
  // _.assert( _.arrayHas( [ 'default', 'resolved', 'throw', 'error' ], o.prefixlessAction ), 'Unknown value of option prefixless action', o.prefixlessAction );
  _.assert( _.arrayIs( o.visited ) );
  // _.assert( !o.defaultResourceKind || !_.path.isGlob( o.defaultResourceKind ), 'Expects non glob {-defaultResourceKind-}' );

  return o;
}

function filesFromResource_body( o )
{
  let module = this;
  let will = module.will;
  _.assert( o.baseModule === module );
  let result = will.Resolver.filesFromResource.body.call( will.Resolver, o );
  return result;
}

_.routineExtend( filesFromResource_body, _.Will.Resolver.filesFromResource );

let filesFromResource = _.routineFromPreAndBody( filesFromResource_pre, filesFromResource_body );

//

let submodulesResolve = _.routineFromPreAndBody( resolve_pre, resolve_body );

_.routineExtend( submodulesResolve, _.Will.Resolver.submodulesResolve );

_.assert( _.Will.Resolver.submodulesResolve.defaults.defaultResourceKind === 'submodule' );
_.assert( submodulesResolve.defaults.defaultResourceKind === 'submodule' );

//

function reflectorResolve_body( o )
{
  let module = this;
  let will = module.will;
  _.assert( o.baseModule === module );
  let result = will.Resolver.reflectorResolve.body.call( will.Resolver, o );
  return result;
}

_.routineExtend( reflectorResolve_body, _.Will.Resolver.reflectorResolve );

let reflectorResolve = _.routineFromPreAndBody( resolve_pre, reflectorResolve_body );

_.assert( reflectorResolve.defaults.defaultResourceKind === 'reflector' );

// --
// other resolver
// --

function _buildsResolve_pre( routine, args )
{
  let module = this;

  _.assert( arguments.length === 2 );
  _.assert( args.length <= 2 );

  let o;
  if( args[ 1 ] !== undefined )
  o = { name : args[ 0 ], criterion : args[ 1 ] }
  else
  o = args[ 0 ];

  o = _.routineOptions( routine, o );
  _.assert( _.arrayHas( [ 'build', 'export' ], o.kind ) );
  _.assert( _.arrayHas( [ 'default', 'more' ], o.preffering ) );
  _.assert( o.criterion === null || _.routineIs( o.criterion ) || _.mapIs( o.criterion ) );

  if( o.preffering === 'default' )
  o.preffering = 'default';

  return o;
}

//

function _buildsResolve_body( o )
{
  let module = this;
  let elements = module.buildMap;

  _.assertRoutineOptions( _buildsResolve_body, arguments );
  _.assert( arguments.length === 1 );

  if( o.name )
  {
    elements = _.mapVals( _.path.globFilterKeys( elements, o.name ) );
    if( !elements.length )
    return []
    if( o.criterion === null || Object.keys( o.criterion ).length === 0 )
    return elements;
  }
  else
  {
    elements = _.mapVals( elements );
  }

  let hasMapFilter = _.objectIs( o.criterion ) && Object.keys( o.criterion ).length > 0;
  if( _.routineIs( o.criterion ) || hasMapFilter )
  {

    _.assert( _.objectIs( o.criterion ), 'not tested' );

    elements = filterWith( elements, o.criterion );

  }
  else if( _.objectIs( o.criterion ) && Object.keys( o.criterion ).length === 0 && !o.name && o.preffering === 'default' )
  {

    elements = filterWith( elements, { default : 1 } );

  }

  if( o.kind === 'export' )
  elements = elements.filter( ( element ) => element.criterion && element.criterion.export );
  else if( o.kind === 'build' )
  elements = elements.filter( ( element ) => !element.criterion || !element.criterion.export );

  return elements;

  /* */

  function filterWith( elements, filter )
  {

    _.assert( _.objectIs( filter ), 'not tested' );

    if( _.objectIs( filter ) && Object.keys( filter ).length > 0 )
    {

      let template = filter;
      filter = function filter( build, k, c )
      {

        _.assert( _.mapIs( build.criterion ) );
        // if( build.criterion === null && Object.keys( template ).length )
        // return;

        // let src = build.criterion;
        // if( !o.strictCriterion )
        // src = _.mapOnly( src, template );

        let satisfied = _.mapSatisfy
        ({
          template,
          src : build.criterion,
          levels : 1,
          strict : o.strictCriterion,
        });

        if( satisfied )
        return build;
      }

    }

    elements = _.entityFilter( elements, filter );

    return elements;
  }

}

_buildsResolve_body.defaults =
{
  kind : null,
  name : null,
  criterion : null,
  preffering : 'default',
  strictCriterion : 1,
}

let _buildsResolve = _.routineFromPreAndBody( _buildsResolve_pre, _buildsResolve_body );

//

let buildsResolve = _.routineFromPreAndBody( _buildsResolve_pre, _buildsResolve_body );
var defaults = buildsResolve.defaults;
defaults.kind = 'build';

//

let exportsResolve = _.routineFromPreAndBody( _buildsResolve_pre, _buildsResolve_body );
var defaults = exportsResolve.defaults;
defaults.kind = 'export';

//

function willfilesResolve()
{
  let module = this;
  let will = module.will;
  _.assert( arguments.length === 0 );

  let result = module.willfilesArray.slice();
  for( let m in module.submoduleMap )
  {
    let submodule = module.submoduleMap[ m ];
    if( !submodule.opener )
    continue;
    if( !submodule.opener.openedModule )
    continue;
    _.arrayAppendArrayOnce( result, submodule.opener.openedModule.willfilesResolve() );
  }

  return result;
}

// --
// exporter
// --

function optionsForOpenerExport()
{
  let module = this;

  _.assert( arguments.length === 0 );

  let fields =
  {

    will : null,
    willfilesArray : null,
    peerModule : null,

    willfilesPath : null,
    localPath : null,
    remotePath : null,

    isRemote : null,
    // isDownloaded : null,
    isUpToDate : null,

  }

  let result = _.mapOnly( module, fields );

  result.isDownloaded = true;
  result.willfilesArray = _.entityMake( result.willfilesArray );

  return result;
}

//

function infoExport( o )
{
  let module = this;
  let will = module.will;
  let result = '';

  o = _.routineOptions( infoExport, arguments );

  if( o.verbosity >= 1 )
  result += module.decoratedAbsoluteName;

  if( o.verbosity >= 3 )
  result += module.about.infoExport();

  if( o.verbosity >= 2 )
  {
    let fields = Object.create( null );
    fields.commonPath = module.commonPath;
    fields.willfilesPath = module.willfilesPath;
    fields.remotePath = module.remotePath;
    fields.localPath = module.localPath;

    fields = module.pathsRelative( module.dirPath, fields );

    result += '\n' + _.toStrNice( fields );
    // result += '\n' + _.toStrNice( fields ) + '\n';
  }

  if( o.verbosity >= 4 )
  {
    result += '\n';
    result += module.infoExportPaths( module.dirPath, module.pathMap );
    result += module.infoExportResource( module.submoduleMap );
    result += module.infoExportResource( module.reflectorMap );
    result += module.infoExportResource( module.stepMap );
    result += module.infoExportResource( module.buildsResolve({ preffering : 'more' }) );
    result += module.infoExportResource( module.exportsResolve({ preffering : 'more' }) );
    result += module.infoExportResource( module.exportedMap );
  }

  return result;
}

infoExport.defaults =
{
  verbosity : 9,
}

//

function infoExportPaths( paths )
{
  let module = this;
  paths = paths || module.pathMap;
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !Object.keys( paths ).length )
  return '';

  let result = _.color.strFormat( 'Paths', 'highlighted' );

  paths = module.pathsRelative( module.dirPath, paths )

  result += '\n' + _.toStrNice( paths ) + '';

  result += '\n\n';

  return result;
}

//

function infoExportResource( collection )
{
  let module = this;
  let will = module.will;
  let result = '';
  let modules = [];

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( collection ) || _.arrayIs( collection ) );

  _.each( collection, ( resource, r ) =>
  {
    if( resource && resource instanceof will.OpenedModule )
    {
      if( _.arrayHas( modules, resource ) )
      return;
      modules.push( resource );
      result += resource.infoExport({ verbosity : 2 });
      result += '\n\n';
    }
    else if( _.instanceIs( resource ) )
    {
      result += resource.infoExport();
      result += '\n\n';
    }
    else
    {
      result = _.toStrNice( resource );
    }
  });

  return result;
}

//

function infoExportModulesTopological()
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  let sorted = will.graphTopologicalSort();
  debugger;

  let result = sorted.map( ( modules ) =>
  {
    let names = modules.map( ( module ) => module.name );
    return names.join( ' ' )
  });

  result = result.join( '\n' );

  return result;
}

//

function structureExport( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  o.dst = o.dst || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  o = _.routineOptions( structureExport, arguments );

  o.module = module;

  if( !o.exportModule )
  o.exportModule = module;

  _.assert( o.exportModule.isOut );

  let o2 = _.mapExtend( null, o );
  delete o2.dst;

  o.dst.about = module.about.structureExport();
  o.dst.path = module.structureExportResources( module.pathResourceMap, o2 );
  o.dst.submodule = module.structureExportResources( module.submoduleMap, o2 );
  o.dst.reflector = module.structureExportResources( module.reflectorMap, o2 );
  o.dst.step = module.structureExportResources( module.stepMap, o2 );
  o.dst.build = module.structureExportResources( module.buildMap, o2 );
  o.dst.exported = module.structureExportResources( module.exportedMap, o2 );
  o.dst.consistency = module.structureExportConsistency( o2 );

  // if( o.rootModule === module )
  // {
  //   let submodules = module.modulesEach({ withPeers : 1, withStem : 1, recursive : 2 })
  //   o.dst.module = module.structureExportModules( submodules, o2 );
  //   // o.dst.module = module.structureExportModules( will.moduleWithCommonPathMap, o2 );
  // }

  return o.dst;
}

structureExport.defaults =
{
  dst : null,
  compact : 1,
  formed : 0,
  copyingAggregates : 0,
  copyingNonExportable : 0,
  copyingNonWritable : 1,
  copyingPredefined : 1,
  strict : 1,
  module : null,
  exportModule : null,
}

//

function structureExportOut( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  o = _.routineOptions( structureExportOut, arguments );

  o.module = module;
  if( !o.exportModule )
  o.exportModule = module;

  _.assert( o.exportModule === module )
  _.assert( o.exportModule.isOut );

  o.dst = o.dst || Object.create( null );
  o.dst.format = will.Willfile.FormatVersion;

  let submodules = module.modulesEach({ withPeers : 1, withStem : 1, recursive : 2 })
  module.structureExportModules( submodules, o );

  return o.dst;
}

structureExportOut.defaults = Object.create( structureExport.defaults );

//

function structureExportForModuleExport( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  o = _.routineOptions( structureExportForModuleExport, arguments );
  _.assert( module.original === null );

  let moduleWas = will.moduleWithCommonPathMap[ module.CommonPathFor( o.willfilesPath ) ];
  if( moduleWas )
  {
    _.assert( moduleWas.peerModule === module );
    _.assert( moduleWas === module.peerModule );
    moduleWas.peerModule = null;
    _.assert( moduleWas.peerModule === null );
    _.assert( module.peerModule === null );
    moduleWas.finit();
    _.assert( moduleWas.finitedIs() );
    _.assert( !module.finitedIs() );
    moduleWas = null;
  }

  let o2 = module.optionsForOpenerExport();
  o2.willfilesPath = o.willfilesPath;
  o2.willfilesArray = [];
  o2.isOut = true;
  o2.peerModule = module;

  let opener2 = will.openerMake({ opener : o2, searching : 'exact' });
  _.assert( opener2.isOut === true );
  _.assert( opener2.superRelation === null );
  _.assert( opener2.rootModule === null );
  _.assert( opener2.openedModule === null );
  _.assert( opener2.willfilesArray.length === 0 );
  _.assert( opener2.peerModule === module );

  opener2.rootModule = module.rootModule || module;
  opener2.original = module;

  /* */

  let o3 = opener2.optionsForModuleExport();
  let rootModule = o3.rootModule = opener2.rootModule; /* xxx : remove rootModule? */
  let module2 = module.cloneExtending( o3 );
  opener2.moduleAdopt( module2 );
  _.assert( rootModule === opener2.rootModule );
  _.assert( rootModule === opener2.openedModule.rootModule );

  /* */

  module2.pathsRebase({ inPath : module.outPath });

  _.assert( module2.dirPath === path.detrail( module.outPath ) );
  _.assert( module2.dirPath === module2.localPath );
  _.assert( module2.original === module );
  _.assert( module2.rootModule === module.rootModule );
  _.assert( module2.willfilesArray.length === 0 );
  _.assert( module2.pathResourceMap.in.path === '.' );
  _.assert( module2.peerModule === module );
  _.assert( module.peerModule === module2 );
  _.assert( opener2.peerModule === module );
  _.assert( opener2.dirPath === path.detrail( module.outPath ) );
  _.assert( opener2.original === module );
  _.assert( opener2.superRelation === null );
  _.assert( opener2.willfilesArray.length === 0 );

  module2.stager.stageStateSkipping( 'picked', 1 );
  module2.stager.stageStateSkipping( 'opened', 1 );
  module2.stager.stageStatePausing( 'picked', 0 );
  module2.stager.tick();

  _.assert( !!module2.ready.resourcesCount() );

  if( module2.ready.errorsCount() )
  module2.ready.sync();

  let structure = module2.structureExportOut();
  let rootModuleStructure = structure.module[ module2.fileName ];

  _.assert( !rootModuleStructure.path || !!rootModuleStructure.path[ 'module.original.willfiles' ] );
  _.assert( !rootModuleStructure.path || !!rootModuleStructure.path[ 'module.peer.willfiles' ] );
  _.assert( !rootModuleStructure.path || !!rootModuleStructure.path[ 'module.willfiles' ] );
  _.assert( !rootModuleStructure.path || !rootModuleStructure.path[ 'module.dir' ] );
  _.assert( !rootModuleStructure.path || rootModuleStructure.path[ 'remote' ] !== undefined );
  _.assert( !rootModuleStructure.path || !rootModuleStructure.path[ 'current.remote' ] );
  _.assert( !rootModuleStructure.path || !rootModuleStructure.path[ 'will' ] );

  opener2.openedModule = null;
  opener2.finit();
  _.assert( !module2.finitedIs() )

  will.openersAdoptModule( module2 );

  if( !module2.isUsed() )
  module2.finit();

  return structure;
}

structureExportForModuleExport.defaults =
{
  willfilesPath : null,
}

//

function structureExportResources( resources, options )
{
  let module = this;
  let will = module.will;
  let result = Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( _.mapIs( resources ) || _.arrayIs( resources ) );

  _.each( resources, ( resource, r ) =>
  {
    result[ r ] = resource.structureExport( options );
    if( result[ r ] === undefined )
    delete result[ r ];
  });

  return result;
}

//

function structureExportModules( modules, op )
{
  let module = this;
  let exportModule = op.exportModule;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  op.dst = op.dst || Object.create( null );
  op.dst.root = [];
  op.dst.consistency = op.dst.consistency || Object.create( null );
  op.dst.module = op.dst.module || Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( exportModule instanceof will.OpenedModule );
  _.assert( exportModule.isOut );

  _.each( modules, ( module2 ) =>
  {
    _.assert( !!module2 );
    let absolute = module2.commonPath;
    let relative = absolute;
    if( !path.isGlobal( relative ) )
    relative = path.relative( exportModule.dirPath, relative );

    _.sure
    (
      module2.isOut || module.commonPath === module2.commonPath || ( module2.peerModule && module2.peerModule.isOut && module2.peerModule.isValid() ),
      `Submodules should be loaded from out-willfiles, but ${module2.decoratedAbsoluteName} is loaded from\n${module2.willfilesPath}`
    );

    if( op.dst.module[ relative ] )
    {
      debugger;
    }
    // else if( absolute === module.commonPath )
    // {
    //   op.dst.module[ relative ] = 'root';
    // }
    else
    {
      let o2 = _.mapExtend( null, op );
      delete o2.dst;
      let moduleStructure = op.dst.module[ relative ] = module2.structureExport( o2 );
      consitencyAdd( moduleStructure.consistency );
    }

    if( absolute === module.commonPath )
    _.arrayAppendOnce( op.dst.root, relative );

    if( op.dst.module[ relative ] === undefined )
    delete op.dst.module[ relative ];

  });

  return op.dst;

  /* */

  function consitencyAdd( consistency )
  {
    _.assert( _.mapIs( consistency ) );
    for( let rel in consistency )
    {
      let src = consistency[ rel ];
      let dst = op.dst.consistency[ rel ];
      if( dst )
      {
        if( dst.hash !== src.hash || dst.size !== src.size )
        throw _.err( `Attempt to put two insconsistent willfiles with the same path "${rel}" in out-file` );
      }
      else
      {
        op.dst.consistency[ rel ] = src;
      }
    }
  }

}

//

function structureExportConsistency( o2 )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.routineOptions( structureExportConsistency, arguments );

  let willfiles = module.willfilesEach({ recursive : 0, withPeers : 1 });

  willfiles.forEach( ( willf ) =>
  {

    _.arrayAs( willf.filePath ).forEach( ( filePath ) =>
    {
      let r = willf.hashDescriptorGet( filePath );
      let relativePath = path.relative( o2.exportModule.inPath, filePath );
      _.assert( result[ relativePath ] === undefined );
      result[ relativePath ] = r;
    });

  });

  return result;
}

structureExportConsistency.defaults = Object.create( structureExport.defaults );

//

function resourceImport( o )
{
  let module = this;
  let will = module.will;

  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 1 );
  _.assert( o.srcResource instanceof will.Resource );
  _.routineOptions( resourceImport, arguments );

  let srcModule = o.srcResource.module;

  _.assert( module instanceof will.OpenedModule );
  _.assert( srcModule === null || srcModule instanceof will.OpenedModule );

  if( o.srcResource.pathsRebase )
  {
    if( o.srcResource.original )
    debugger;
    if( o.srcResource.original )
    o.srcResource = o.srcResource.original;

    _.assert( o.srcResource.original === null );

    o.srcResource = o.srcResource.cloneDerivative();

    // _.assert( o.srcResource.openedModule === srcModule )

    o.srcResource.pathsRebase
    ({
      exInPath : srcModule.inPath,
      inPath : module.inPath,
    });

  }

  let resourceData = o.srcResource.structureExport();

  if( _.mapIs( resourceData ) )
  for( let k in resourceData )
  {
    let value = resourceData[ k ];

    if( _.strIs( value ) && srcModule )
    value = srcModule.resolveMaybe
    ({
      selector : value,
      prefixlessAction : 'resolved',
      pathUnwrapping : 0,
      pathResolving : 0,
      currentContext : o.srcResource,
    });

    if( _.instanceIsStandard( value ) )
    {
      let o2 = _.mapExtend( null, o );
      o2.srcResource = value;
      let subresource = module.resourceImport( o2 );
      value = subresource.qualifiedName;
    }

    resourceData[ k ] = value;
  }

  if( o.overriding )
  {
    let oldResource = module.resourceGet( o.srcResource.KindName, o.srcResource.name );
    if( oldResource )
    {
      debugger;
      let extra = oldResource.extraExport();
      debugger;
      _.mapExtend( resourceData, extra );

      // resourceData.writable = oldResource.writable;
      // resourceData.exportable = oldResource.exportable;
      // resourceData.importableFromIn = oldResource.importableFromIn;
      // resourceData.importableFromOut = oldResource.importableFromOut;

      oldResource.finit();
    }
  }

  _.assert( _.mapIs( resourceData ) );

  resourceData.module = module;
  resourceData.name = module.resourceNameAllocate( o.srcResource.KindName, o.srcResource.name );

  // logger.log( ` . importing ${o.srcResource.qualifiedName} as ${o.srcResource.KindName}::${resourceData.name}` ); debugger;

  let resource = new o.srcResource.Self( resourceData );
  resource.form1();
  _.assert( module.resolve({ selector : resource.qualifiedName, pathUnwrapping : 0, pathResolving : 0 }).absoluteName === resource.absoluteName );

  return resource;
}

resourceImport.defaults =
{
  srcResource : null,
  overriding : 1,
}

//

function ResourceSetter_functor( op )
{
  _.routineOptions( ResourceSetter_functor, arguments );

  let resourceName = op.resourceName;
  let mapName = op.mapName;
  let mapSymbol = Symbol.for( mapName );

  return function resourceSet( resourceMap2 )
  {
    let module = this;
    let resourceMap = module[ mapSymbol ] = module[ mapSymbol ] || Object.create( null );

    _.assert( arguments.length === 1 );
    _.assert( _.mapIs( resourceMap ) );
    _.assert( _.mapIs( resourceMap2 ) );

    for( let m in resourceMap )
    {
      let resource = resourceMap[ m ];
      _.assert( _.instanceIs( resource ) );
      _.assert( resource.module === module );

      if( !resource.importableFromIn && !resource.importableFromOut )
      continue;
      resource.finit();
      _.assert( resourceMap[ m ] === undefined );
    }

    if( resourceMap2 === null )
    return resourceMap;

    for( let m in resourceMap2 )
    {
      let resource = resourceMap2[ m ];

      _.assert( module.preformed === 0 );
      _.assert( _.instanceIs( resource ) );
      _.assert( resource.module !== module );

      if( resourceMap[ m ] )
      continue;

      if( resource.module !== null )
      resource = resource.clone();
      _.assert( resource.formed === 0 );
      // _.assert( resource.module === null );
      resource.module = module;
      resource.form1();
      _.assert( !_.workpiece.isFinited( resource ) );
    }

    return resourceMap;
  }

}

ResourceSetter_functor.defaults =
{
  resourceName : null,
  mapName : null,
}

// --
// etc
// --

function shell( o )
{
  let module = this;
  let will = module.will;
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;

  if( !_.mapIs( arguments[ 0 ] ) )
  o = { execPath : arguments[ 0 ] }

  o = _.routineOptions( shell, o );
  _.assert( _.strIs( o.execPath ) );
  _.assert( arguments.length === 1 );
  _.assert( o.verbosity === null || _.numberIs( o.verbosity ) );

  /* */

  o.execPath = module.resolve
  ({
    selector : o.execPath,
    prefixlessAction : 'resolved',
    currentThis : o.currentThis,
    currentContext : o.currentContext,
    pathNativizing : 1,
    arrayFlattening : 0, /* required for f::this and feature make */
  });

  /* */

  if( o.currentPath )
  o.currentPath = module.pathResolve({ selector : o.currentPath, prefixlessAction : 'resolved', currentContext : o.currentContext });
  _.sure( o.currentPath === null || _.strIs( o.currentPath ) || _.strsAreAll( o.currentPath ), 'Current path should be string if defined' );

  /* */

  let ready = new _.Consequence().take( null );

  _.process.start
  ({
    execPath : o.execPath,
    currentPath : o.currentPath,
    verbosity : o.verbosity !== null ? o.verbosity : will.verbosity - 1,
    ready : ready,
  });

  return ready;
}

shell.defaults =
{
  execPath : null,
  currentPath : null,
  currentThis : null,
  currentContext : null,
  verbosity : null,
}

//

function errTooMany( builds, what )
{
  let module = this;
  let will = module.will;
  let logger = will.logger;
  let prefix = '';
  let err;

  if( logger.verbosity >= 2 && builds.length > 1 )
  {
    // logger.up();
    // logger.log( module.infoExportResource( builds ) );
    // logger.down();
    prefix = module.infoExportResource( builds );
  }

  if( builds.length !== 1 )
  {
    debugger;
    if( builds.length === 0 )
    err = _.errBrief( prefix, '\nPlease specify exactly one ' + what + ', none satisfies passed arguments' );
    else
    err = _.errBrief( prefix, '\nPlease specify exactly one ' + what + ', ' + builds.length + ' satisfy(s)' + '\nFound : ' + _.strQuote( _.select( builds, '*/name' ) ) );
    return err;
  }

  return false;
}

// --
// relations
// --

let rootModuleSymbol = Symbol.for( 'rootModule' );
let peerModuleSymbol = Symbol.for( 'peerModule' );
let superRelationsSymbol = Symbol.for( 'superRelations' );

let Composes =
{

  willfilesPath : null,
  inPath : null,
  outPath : null,
  localPath : null,
  remotePath : null,

  isRemote : null,
  // isDownloaded : null,
  isUpToDate : null,
  isOut : null,

  verbosity : 0,

}

let Aggregates =
{

  about : _.define.instanceOf( _.Will.ParagraphAbout ),
  submoduleMap : _.define.own({}),
  pathResourceMap : _.define.own({}),
  reflectorMap : _.define.own({}),
  stepMap : _.define.own({}),
  buildMap : _.define.own({}),
  exportedMap : _.define.own({}),

}

let Associates =
{

  will : null,
  rootModule : null,
  superRelations : _.define.own([]),
  original : null,
  willfilesArray : _.define.own([]),
  storedWillfilesArray : _.define.own([]),

}

let Medials =
{
}

let Restricts =
{

  id : null,
  stager : null,

  _registeredPath : null,

  pathMap : _.define.own({}),
  moduleWithNameMap : null,
  userArray : _.define.own([]),

  predefinedFormed : 0,
  preformed : 0,
  picked : 0,
  opened : 0,
  attachedWillfilesFormed : 0,
  peerModulesFormed : 0,
  subModulesFormed : 0,
  resourcesFormed : 0,
  formed : 0,

  preformReady : _.define.own( _.Consequence({ capacity : 1, tag : 'preformReady' }) ),
  pickedReady : _.define.own( _.Consequence({ capacity : 1, tag : 'pickedReady' }) ),
  openedReady : _.define.own( _.Consequence({ capacity : 1, tag : 'openedReady' }) ),
  attachedWillfilesFormReady : _.define.own( _.Consequence({ capacity : 1, tag : 'attachedWillfilesFormReady' }) ),
  peerModulesFormReady : _.define.own( _.Consequence({ capacity : 1, tag : 'peerModulesFormReady' }) ),
  subModulesFormReady : _.define.own( _.Consequence({ capacity : 1, tag : 'subModulesFormReady' }) ),
  resourcesFormReady : _.define.own( _.Consequence({ capacity : 1, tag : 'resourcesFormReady' }) ),
  ready : _.define.own( _.Consequence({ capacity : 1, tag : 'ready' }) ),

}

let Statics =
{

  ResourceSetter_functor,

}

let Forbids =
{

  exportMap : 'exportMap',
  exported : 'exported',
  export : 'export',
  downloaded : 'downloaded',
  formReady : 'formReady',
  filePath : 'filePath',
  errors : 'errors',
  associatedSubmodule : 'associatedSubmodule',
  execution : 'execution',
  allModuleMap : 'allModuleMap',
  Counter : 'Counter',
  pickedWillfilesPath : 'pickedWillfilesPath',
  supermodule : 'supermodule',
  submoduleAssociation : 'submoduleAssociation',
  pickedWillfileData : 'pickedWillfileData',
  willfilesFound : 'willfilesFound',
  willfilesOpened : 'willfilesOpened',
  willfilesFindReady : 'willfilesFindReady',
  willfilesOpenReady : 'willfilesOpenReady',
  aliasName : 'aliasName',
  moduleWithCommonPathMap : 'moduleWithCommonPathMap',
  openedModule : 'openedModule',
  openerModule : 'openerModule',
  willfilesReadTimeReported : 'willfilesReadTimeReported',
  willfilesReadBeginTime : 'willfilesReadBeginTime',
  isDownloaded : 'isDownloaded',
  isOutFile : 'isOutFile',

}

let Accessors =
{

  about : { setter : _.accessor.setter.friend({ name : 'about', friendName : 'module', maker : _.Will.ParagraphAbout }) },
  rootModule : { getter : rootModuleGet, setter : rootModuleSet },
  peerModule : { setter : peerModuleSet },
  // isDownloaded : { setter : remoteIsDownloadedSet },
  // willfilesArray : { setter : willfileArraySet },
  // willfileWithRoleMap : { readOnly : 1 },

  submoduleMap : { setter : ResourceSetter_functor({ resourceName : 'ModulesRelation', mapName : 'submoduleMap' }) },
  pathResourceMap : { setter : ResourceSetter_functor({ resourceName : 'PathResource', mapName : 'pathResourceMap' }) },
  reflectorMap : { setter : ResourceSetter_functor({ resourceName : 'Reflector', mapName : 'reflectorMap' }) },
  stepMap : { setter : ResourceSetter_functor({ resourceName : 'Step', mapName : 'stepMap' }) },
  buildMap : { setter : ResourceSetter_functor({ resourceName : 'Build', mapName : 'buildMap' }) },
  exportedMap : { setter : ResourceSetter_functor({ resourceName : 'Exported', mapName : 'exportedMap' }) },
  superRelations : { setter : superRelationsSet },

  name : { getter : nameGet, readOnly : 1 },
  absoluteName : { getter : absoluteNameGet, readOnly : 1 },
  aliasNames : { getter : aliasNamesGet, readOnly : 1 },
  // configName : { readOnly : 1 },

  willfilesPath : { getter : willfilesPathGet, setter : willfilesPathSet },
  inPath : { getter : inPathGet, setter : inPathSet },
  outPath : { getter : outPathGet, setter : outPathSet },
  localPath : { getter : localPathGet, setter : localPathSet },
  remotePath : { getter : remotePathGet, setter : remotePathSet },
  dirPath : { getter : dirPathGet, readOnly : 1 },
  commonPath : { getter : commonPathGet, readOnly : 1 },
  currentRemotePath : { getter : currentRemotePathGet, readOnly : 1 },
  willPath : { getter : willPathGet, readOnly : 1 },
  originalWillfilesPath : { getter : originalWillfilesPathGet, readOnly : 1 },
  peerWillfilesPath : { getter : peerWillfilesPathGet, readOnly : 1 },

  decoratedWillfilesPath : { getter : decoratedWillfilesPathGet, readOnly : 1, },
  decoratedInPath : { getter : decoratedInPathGet, readOnly : 1, },
  decoratedOutPath : { getter : decoratedOutPathGet, readOnly : 1, },
  decoratedLocalPath : { getter : decoratedLocalPathGet, readOnly : 1, },
  decoratedRemotePath : { getter : decoratedRemotePathGet, readOnly : 1, },
  decoratedDirPath : { getter : decoratedDirPathGet, readOnly : 1 },
  decoratedCommonPath : { getter : decoratedCommonPathGet, readOnly : 1 },
  decoratedCurrentRemotePath : { getter : decoratedCurrentRemotePathGet, readOnly : 1 },
  decoratedWillPath : { getter : decoratedWillPathGet, readOnly : 1 },
  decoratedOriginalWillfilesPath : { getter : decoratedOriginalWillfilesPathGet, readOnly : 1 },
  decoratedPeerWillfilesPath : { getter : decoratedPeerWillfilesPathGet, readOnly : 1 },

}

// --
// declare
// --

let Extend =
{

  // inter

  finit,
  init,

  openerMake,
  releasedBy,
  usedBy,
  isUsedBy,
  isUsed,

  precopy,
  copy,
  clone,
  cloneExtending,
  unform,
  preform,
  _preform,
  predefinedForm,
  upform,
  reform_,

  // opener

  isOpened,
  isValid,
  isConsistent,
  isFull,
  close,
  _formEnd,

  // willfiles

  _willfilesPicked,

  willfilesOpen,
  _willfilesOpen,

  _willfilesReadBegin,
  _willfilesReadEnd,

  willfileUnregister,
  willfileRegister,

  _willfilesExport,
  willfilesEach,

  _attachedWillfilesForm,
  _attachedWillfilesOpenFromData,
  _attachedWillfileOpenFromData,

  // build / export

  exportAuto,
  moduleBuild,
  moduleExport,

  // batcher

  modulesEach,
  modulesEachDo,
  modulesBuild,
  modulesExport,
  modulesUpform,

  // submodule

  rootModuleGet,
  rootModuleSet,
  superRelationsSet,

  submodulesAreDownloaded,
  submodulesAllAreDownloaded,
  submodulesAreValid,
  submodulesAllAreValid,
  submodulesClean,

  _subModulesDownload,
  subModulesDownload,
  submodulesUpdate,

  submodulesFixate,
  moduleFixate,
  moduleFixateAct,
  moduleFixatePathFor,

  submodulesReload,
  submodulesForm,
  _subModulesForm,

  // _attachedModulesOpen,
  // _attachedModulesOpenFromData,
  // _attachedModuleOpenFromData,

  // peer

  peerModuleOpen,
  _peerModulesForm,
  _peerChanged,
  peerModuleSet,
  peerWillfilesPathFromWillfiles,
  submodulesPeersOpen,

  // remote

  _remoteChanged,
  // remoteIsDownloadedChanged,
  // remoteIsDownloadedSet,

  // resource

  resourcesForm,
  _resourcesForm,
  _resourcesFormAct,
  _resourcesAllForm,

  resourceClassForKind,
  resourceMapForKind,
  resourceMapsForKind,
  resourceMaps,
  resourceGet,
  resourceObtain,
  resourceAllocate,
  resourceNameAllocate,

  // path

  pathsRelative,
  pathsRebase,

  _filePathChange,
  inPathGet,
  outPathGet,
  outfilePathGet,
  cloneDirPathGet,

  willfilesPathGet,
  dirPathGet,
  commonPathGet,
  localPathGet,
  remotePathGet,
  currentRemotePathGet,
  willPathGet,
  originalWillfilesPathGet,
  peerWillfilesPathGet,

  decoratedWillfilesPathGet,
  decoratedInPathGet,
  decoratedOutPathGet,
  decoratedDirPathGet,
  decoratedCommonPathGet,
  decoratedLocalPathGet,
  decoratedRemotePathGet,
  decoratedCurrentRemotePathGet,
  decoratedWillPathGet,
  decoratedOriginalWillfilesPathGet,
  decoratedPeerWillfilesPathGet,

  _inPathAssign,
  _outPathAssign,
  _willfilesPathAssign,
  _dirPathAssign,
  _commonPathAssign,
  _localPathAssign,
  _remotePathAssign,
  _originalWillfilesPathAssign,
  _peerWillfilesPathAssign,

  inPathSet,
  outPathSet,
  willfilesPathSet,
  localPathSet,
  remotePathSet,

  // name

  nameGet,
  _nameChanged,
  _nameUnregister,
  _nameRegister,
  absoluteNameGet,
  shortNameArrayGet,

  // clean

  cleanWhatSingle,
  cleanWhat,
  cleanWhatReport,
  clean,

  // resolver

  resolve,

  resolveMaybe,
  resolveRaw,
  pathResolve,
  pathOrReflectorResolve,
  filesFromResource,
  submodulesResolve,
  reflectorResolve,

  // other resolver

  _buildsResolve,
  buildsResolve,
  exportsResolve,
  willfilesResolve,

  // exporter

  optionsForOpenerExport,

  infoExport,
  infoExportPaths,
  infoExportResource,
  infoExportModulesTopological,

  structureExport,
  structureExportOut,
  structureExportForModuleExport,
  structureExportResources,
  structureExportModules,
  structureExportConsistency,

  resourceImport,

  // etc

  shell,
  errTooMany,

  // relation

  Composes,
  Aggregates,
  Associates,
  Medials,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

_.staticDeclare
({
  prototype : _.Will.prototype,
  name : Self.shortName,
  value : Self,
});

})();
