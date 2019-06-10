( function _MainTop_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './MainBase.s' );

}

//

let _ = wTools;
let Parent = null;
let Self = _.Will;

// --
// exec
// --

function Exec()
{
  let will = new this.Self();
  return will.exec();
}

//

function exec()
{
  let will = this;

  will.formAssociates();

  _.assert( _.instanceIs( will ) );
  _.assert( arguments.length === 0 );

  let logger = will.logger;
  let fileProvider = will.fileProvider;
  let appArgs = _.appArgs({ keyValDelimeter : 0 });
  let ca = will.commandsMake();

  return ca.appArgsPerform({ appArgs : appArgs });
}

//

function _moduleReadyThen( o )
{
  let will = this.form();
  let fileProvider = will.fileProvider;
  let path = will.fileProvider.path;
  let logger = will.logger;
  let willfilesPath = fileProvider.path.current();

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( o.onReady ) );
  _.routineOptions( _moduleReadyThen, arguments );

  if( !will.topCommand )
  will.topCommand = o.onReady;

  let module = will.currentModule;
  if( !module )
  module = will.currentModule = will.moduleMake
  ({
    willfilesPath : willfilesPath,
    forming : o.forming,
  });

  if( o.forming && module.openedModule.stager.stageStateSkipping( 'resourcesFormed' ) )
  {
    module.openedModule.stager.stageRerun( 'resourcesFormed' );
  }

  return will.currentModule.openedModule.ready.split().keep( function( arg )
  {
    let result = o.onReady( module );
    _.assert( result !== undefined );
    return result;
  })
  .finally( ( err, arg ) =>
  {
    will.moduleDone({ error : err || null, command : o.onReady });
    if( err )
    throw err;
    return arg;
  })
  ;

}

_moduleReadyThen.defaults =
{
  onReady : null,
  forming : null,
}

//

function moduleReadyThen( onReady )
{
  let will = this.form();
  _.assert( arguments.length === 1 );
  return will._moduleReadyThen
  ({
    onReady : onReady,
    forming : 1,
  });
}

//

function moduleReadyThenNonForming( onReady )
{
  let will = this.form();
  _.assert( arguments.length === 1 );
  return will._moduleReadyThen
  ({
    onReady : onReady,
    forming : 0,
  });
}

//

function moduleDone( o )
{
  let will = this;
  let fileProvider = will.fileProvider;
  let path = will.fileProvider.path;
  let logger = will.logger;

  _.assertRoutineOptions( moduleDone, arguments );
  _.assert( _.routineIs( o.command ) );
  _.assert( _.routineIs( will.topCommand ) );
  _.assert( arguments.length === 1 );
  _.assert( will.formed === 1 );

  if( o.error )
  {
    _.appExitCode( -1 );
    _.errLogOnce( o.error );
  }

  try
  {

    if( will.topCommand === o.command )
    {
      if( will.beeping )
      _.diagnosticBeep();

      will.currentPath = null;
      will.currentModule = null;
      will.topCommand = null;
      let currentModule = will.currentModule;
      if( currentModule )
      currentModule.finit();
      _.procedure.terminationBegin();
      return true;
    }

  }
  catch( err )
  {
    _.appExitCode( -1 );
    _.errLogOnce( err );
    debugger;
    will.currentPath = null;
    will.currentModule = null;
    will.topCommand = null;
    return true;
  }

  return false;
}

moduleDone.defaults =
{
  error : null,
  command : null,
}

//

function errTooMany( elements, what )
{
  let will = this;

  if( elements.length !== 1 )
  {
    debugger;
    if( elements.length === 0 )
    return _.errBriefly( 'Please specify exactly one ' + what + ', none satisfies passed arguments' );
    else
    return _.errBriefly( 'Please specify exactly one ' + what + ', ' + elements.length + ' satisfy(s)' + '\nFound : ' + _.strQuote( _.select( elements, '*/name' ) ) );
  }

  return false;
}

//

function currentModuleSet( src )
{
  let will = this;

  _.assert( src === null || src instanceof will.OpenerModule );

  will[ currentModuleSymbol ] = src;
  return src;
}

//

function commandsMake()
{
  let will = this;
  let logger = will.logger;
  let fileProvider = will.fileProvider;
  let appArgs = _.appArgs();

  _.assert( _.instanceIs( will ) );
  _.assert( arguments.length === 0 );

  let commands =
  {

    'help' :                    { e : _.routineJoin( will, will.commandHelp ),                  h : 'Get help.' },
    'set' :                     { e : _.routineJoin( will, will.commandSet ),                   h : 'Command set.' },

    'resources list' :          { e : _.routineJoin( will, will.commandResourcesList ),         h : 'List information about resources of the current module.' },
    'paths list' :              { e : _.routineJoin( will, will.commandPathsList ),             h : 'List paths of the current module.' },
    'submodules list' :         { e : _.routineJoin( will, will.commandSubmodulesList ),        h : 'List submodules of the current module.' },
    'reflectors list' :         { e : _.routineJoin( will, will.commandReflectorsList ),        h : 'List avaialable reflectors the current module.' },
    'steps list' :              { e : _.routineJoin( will, will.commandStepsList ),             h : 'List avaialable steps the current module.' },
    'builds list' :             { e : _.routineJoin( will, will.commandBuildsList ),            h : 'List avaialable builds the current module.' },
    'exports list' :            { e : _.routineJoin( will, will.commandExportsList ),           h : 'List avaialable exports the current module.' },
    'about list' :              { e : _.routineJoin( will, will.commandAboutList ),             h : 'List descriptive information about the current module.' },

    'submodules clean' :        { e : _.routineJoin( will, will.commandSubmodulesClean ),       h : 'Delete all downloaded submodules.' },
    'submodules download' :     { e : _.routineJoin( will, will.commandSubmodulesDownload ),    h : 'Download each submodule if such was not downloaded so far.' },
    'submodules update' :       { e : _.routineJoin( will, will.commandSubmodulesUpdate ),      h : 'Update each submodule, checking for available updates for each submodule. Does nothing if all submodules have fixated version.' },
    'submodules fixate' :       { e : _.routineJoin( will, will.commandSubmodulesFixate ),      h : 'Fixate remote submodules. If URI of a submodule does not contain a version then version will be appended.' },
    'submodules upgrade' :      { e : _.routineJoin( will, will.commandSubmodulesUpgrade ),     h : 'Upgrade remote submodules. If a remote repository has any newer version of the submodule, then URI of the submodule will be upgraded with the latest available version.' },

    'shell' :                   { e : _.routineJoin( will, will.commandShell ),                 h : 'Execute shell command on the module.' },
    'clean' :                   { e : _.routineJoin( will, will.commandClean ),                 h : 'Clean current module. Delete genrated artifacts, temp files and downloaded submodules.' },
    'build' :                   { e : _.routineJoin( will, will.commandBuild ),                 h : 'Build current module with spesified criterion.' },
    'export' :                  { e : _.routineJoin( will, will.commandExport ),                h : 'Export selected the module with spesified criterion. Save output to output file and archive.' },
    'with' :                    { e : _.routineJoin( will, will.commandWith ),                  h : 'Use "with" to select a module.' },
    'each' :                    { e : _.routineJoin( will, will.commandEach ),                  h : 'Use "each" to iterate each module in a directory.' },

  }

  let ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands : commands,
    commandPrefix : 'node ',
    logger : will.logger,
  })

  _.assert( ca.logger === will.logger );
  _.assert( ca.verbosity === will.verbosity );

  //will._commandsConfigAdd( ca );

  ca.form();

  return ca;
}


//

function commandHelp( e )
{
  let will = this;
  let ca = e.ca;
  let logger = will.logger;

  // debugger;
  ca._commandHelp( e );

  if( !e.subject )
  {
    _.assert( 0 );
    // logger.log( 'Use ' + logger.colorFormat( '"will .help"', 'code' ) + ' to get help' );
  }

}

//

function commandSet( e )
{
  let will = this;
  let ca = e.ca;
  let logger = will.logger;

  let namesMap =
  {
    v : 'verbosity',
    verbosity : 'verbosity',
    beeping : 'beeping',
  }

  let request = _.strRequestParse( e.argument );

  _.appArgsReadTo
  ({
    dst : will,
    propertiesMap : request.map,
    namesMap : namesMap,
  });

}

//

function _commandList( e, act, resourceName )
{
  let will = this;

  _.assert( arguments.length === 3 );

  return will.moduleReadyThen( function( module )
  {

    let resources = null;
    if( resourceName )
    {

      let selectorIsGlob = _.path.isGlob( resourceName );
      _.assert( e.request === undefined );
      e.request = _.strRequestParse( e.argument );

      if( selectorIsGlob && e.request.subject && !module.openedModule.SelectorIs( e.request.subject ) )
      {
        e.request.subject = '*::' + e.request.subject;
      }

      let o2 =
      {
        selector : selectorIsGlob ? ( e.request.subject || '*::*' ) : ( e.request.subject || '*' ),
        criterion : e.request.map,
        defaultResourceName : selectorIsGlob ? null : resourceName,
        prefixlessAction : selectorIsGlob ? 'throw' : 'default',
        arrayWrapping : 1,
        pathUnwrapping : selectorIsGlob ? 0 : 1,
        pathResolving : 0,
        mapValsUnwrapping : selectorIsGlob ? 0 : 1,
        strictCriterion : 1,
      }

      if( resourceName === 'path' )
      o2.mapValsUnwrapping = 0;

      resources = module.openedModule.resolve( o2 );

    }

    return act( module, resources ) || null;
  });

}

//

function commandResourcesList( e )
{
  let will = this;

  function act( module, resources )
  {
    let logger = will.logger;

    if( !e.request.subject && !_.mapKeys( e.request.map ).length )
    {

      let result = '';
      result += module.openedModule.about.infoExport();

      logger.log( result );

    }

    logger.log( module.openedModule.infoExportResource( resources ) );

  }

  return will._commandList( e, act, '*' );

}

//

function commandPathsList( e )
{
  let will = this;

  function act( module, resources )
  {

    let logger = will.logger;
    logger.log( module.openedModule.infoExportPaths( resources ) );

  }

  return will._commandList( e, act, 'path' );
}

//

function commandSubmodulesList( e )
{
  let will = this;

  function act( module, resources )
  {
    let logger = will.logger;
    debugger;
    logger.log( module.openedModule.infoExportResource( resources ) );
  }

  return will._commandList( e, act, 'submodule' );
}

//

function commandReflectorsList( e )
{
  let will = this;

  function act( module, resources )
  {
    let logger = will.logger;
    logger.log( module.openedModule.infoExportResource( resources ) );
  }

  return will._commandList( e, act, 'reflector' );
}

//

function commandStepsList( e )
{
  let will = this;

  function act( module, resources )
  {
    let logger = will.logger;

    // let request = _.strRequestParse( e.argument );
    //
    // let steps = module.openedModule.resolve
    // ({
    //   selector : request.subject || '*',
    //   defaultResourceName : 'step',
    //   prefixlessAction : 'default',
    //   criterion : request.map,
    //   arrayWrapping : 1,
    // });

    logger.log( module.openedModule.infoExportResource( resources ) );
  }

  return will._commandList( e, act, 'step' );
}

//

function commandBuildsList( e )
{
  let will = this;

  function act( module )
  {
    let logger = will.logger;
    let request = _.strRequestParse( e.argument );
    debugger;
    let builds = module.openedModule.buildsResolve
    ({
      name : request.subject,
      criterion : request.map,
      preffering : 'more',
    });
    logger.log( module.openedModule.infoExportResource( builds ) );
  }

  will._commandList( e, act, null );

  return will;
}

//

function commandExportsList( e )
{
  let will = this;

  function act( module )
  {
    let logger = will.logger;
    let request = _.strRequestParse( e.argument );
    debugger;
    let builds = module.openedModule.exportsResolve
    ({
      name : request.subject,
      criterion : request.map,
      preffering : 'more',
    });
    logger.log( module.openedModule.infoExportResource( builds ) );
  }

  will._commandList( e, act, null );

  return will;
}

//

function commandAboutList( e )
{
  let will = this;

  function act( module )
  {
    let logger = will.logger;
    logger.log( module.openedModule.about.infoExport() );
  }

  will._commandList( e, act, null );

  return will;
}

//

function commandSubmodulesClean( e )
{
  let will = this;
  return will.moduleReadyThenNonForming( function( module )
  {
    return module.openedModule.submodulesClean();
  });
}

//

function commandSubmodulesDownload( e )
{
  let will = this;

  let propertiesMap = _.strToMap( e.argument );
  e.propertiesMap = _.mapExtend( e.propertiesMap, propertiesMap )

  return will.moduleReadyThenNonForming( function( module )
  {
    return module.openedModule.submodulesDownload({ dry : e.propertiesMap.dry });
  });
}

commandSubmodulesDownload.commandProperties =
{
  dry : 'Dry run without actually writing or deleting files. Default is dry:0.',
}

//

function commandSubmodulesUpdate( e )
{
  let will = this;

  let propertiesMap = _.strToMap( e.argument );
  e.propertiesMap = _.mapExtend( e.propertiesMap, propertiesMap )

  return will.moduleReadyThenNonForming( function( module )
  {
    return module.openedModule.submodulesUpdate({ dry : e.propertiesMap.dry });
  });
}

commandSubmodulesUpdate.commandProperties =
{
  dry : 'Dry run without actually writing or deleting files. Default is dry:0.',
}

//

function commandSubmodulesFixate( e )
{
  let will = this;

  let propertiesMap = _.strToMap( e.argument );
  e.propertiesMap = _.mapExtend( e.propertiesMap, propertiesMap )

  e.propertiesMap.reportingNegative = e.propertiesMap.negative;
  delete e.propertiesMap.negative;

  return will.moduleReadyThenNonForming( function( module )
  {
    return module.openedModule.submodulesFixate( e.propertiesMap );
  });

}

commandSubmodulesFixate.commandProperties =
{
  dry : 'Dry run without writing. Default is dry:0.',
  negative : 'Reporting attempt of upgrade with negative outcome. Default is negative:0.',
}

//

function commandSubmodulesUpgrade( e )
{
  let will = this;

  let propertiesMap = _.strToMap( e.argument );
  e.propertiesMap = _.mapExtend( e.propertiesMap, propertiesMap )

  _.assert( e.propertiesMap.upgrading === undefined, 'Unknown option upgrading' );

  e.propertiesMap.upgrading = 1;
  e.propertiesMap.reportingNegative = e.propertiesMap.negative;
  delete e.propertiesMap.negative;

  return will.moduleReadyThenNonForming( function( module )
  {
    return module.openedModule.submodulesFixate( e.propertiesMap );
  });

}

commandSubmodulesUpgrade.commandProperties =
{
  dry : 'Dry run without writing. Default is dry:0.',
  negative : 'Reporting attempt of upgrade with negative outcome. Default is negative:0.',
}

//

function commandShell( e )
{
  let will = this;

  return will.moduleReadyThenNonForming( function( module )
  {
    let logger = will.logger;
    return module.openedModule.shell
    ({
      execPath : e.argument,
      currentPath : will.currentPath || module.openedModule.dirPath,
    });
  });

}

//

function commandClean( e )
{
  let will = this;

  let propertiesMap = _.strToMap( e.argument );
  e.propertiesMap = _.mapExtend( e.propertiesMap, propertiesMap )

  return will.moduleReadyThenNonForming( function( module )
  {
    let logger = will.logger;

    if( e.propertiesMap.dry )
    return module.openedModule.cleanWhatReport();
    else
    return module.openedModule.clean();

  });

}

commandClean.commandProperties =
{
  dry : 'Dry run without deleting. Default is dry:0.',
}

//

function commandBuild( e )
{
  let will = this;
  return will.moduleReadyThenNonForming( function( module )
  {
    let request = _.strRequestParse( e.argument );
    let builds = module.openedModule.buildsResolve( request.subject, request.map );
    let logger = will.logger;

    if( logger.verbosity >= 2 && builds.length > 1 )
    {
      logger.up();
      logger.log( module.openedModule.infoExportResource( builds ) );
      logger.down();
    }

    if( builds.length !== 1 )
    throw errTooMany( builds, 'build scenario' );

    let build = builds[ 0 ];
    return build.perform();
  });
}

//

function commandExport( e )
{
  let will = this;
  return will.moduleReadyThen( function( module )
  {
    let request = _.strRequestParse( e.argument );
    let builds = module.openedModule.exportsResolve( request.subject, request.map );

    if( logger.verbosity >= 2 && builds.length > 1 )
    {
      logger.up();
      logger.log( module.openedModule.infoExportResource( builds ) );
      logger.down();
    }

    if( builds.length !== 1 )
    throw errTooMany( builds, 'export scenario' );

    let build = builds[ 0 ];
    return build.perform()
  });
}

//

function commandWith( e )
{
  let will = this.form();
  let ca = e.ca;
  let fileProvider = will.fileProvider;
  let path = will.fileProvider.path;
  let logger = will.logger;

  if( will.currentModule )
  {
    debugger;
    will.currentPath = null;
    will.currentModule.finit();
    will.currentModule = null;
  }

  _.sure( _.strDefined( e.argument ), 'Expects path to module' );
  _.assert( arguments.length === 1 );

  if( will.topCommand === null )
  will.topCommand = commandWith;

  let isolated = ca.commandIsolateSecondFromArgument( e.argument );
  let dirPath = path.joinRaw( path.current(), isolated.argument );

  let module = will.currentModule = will.OpenerModule({ will : will, willfilesPath : dirPath });

  will.currentModule.open();

  // module.openedModule.stager.stageStateSkipping( 'submodulesFormed', 1 );
  module.openedModule.stager.stageStateSkipping( 'resourcesFormed', 1 );
  module.openedModule.stager.stageStatePausing( 'opened', 0 );

  // module.openedModule.willfilesFind();
  module.openedModule.stager.tick();

  return module.openedModule.ready.split().keep( function( arg )
  {

    _.assert( will.currentModule.willfileArray.length > 0 );

    return ca.commandPerform
    ({
      command : isolated.secondCommand,
    });

  })
  .finally( ( err, arg ) =>
  {
    will.moduleDone({ error : err || null, command : commandWith });
    if( err )
    throw _.errLogOnce( err );
    return arg;
  });

}

//

function _commandEach_functor( fop )
{

  fop = _.routineOptions( _commandEach_functor, arguments );

  _.assert( _.arrayHas( [ 'all', 'local', 'remote' ], fop.filtering ) );

  return function commandEach( e )
  {
    let will = this.form();
    let ca = e.ca;
    let fileProvider = will.fileProvider;
    let path = will.fileProvider.path;
    let logger = will.logger;

    if( will.currentModule )
    {
      will.currentPath = null;
      will.currentModule.finit();
      will.currentModule = null;
    }

    _.sure( _.strDefined( e.argument ), 'Expects path to module' )
    _.assert( arguments.length === 1 );

    if( will.topCommand === null )
    will.topCommand = commandEach;

    let isolated = ca.commandIsolateSecondFromArgument( e.argument );

    _.assert( _.objectIs( isolated ), 'Command .each should go with the second command to apply to each module. For example : ".each submodule::* .shell ls -al"' );

    let con = will.moduleEach
    ({
      selector : isolated.argument,
      onBegin : handleBegin,
      onEnd : handleEnd,
    });

    con.finally( ( err, arg ) =>
    {
      will.moduleDone({ error : err || null, command : commandEach });
      if( err )
      throw _.errLogOnce( err );
      return arg;
    });

    return con;

    /* */

    function handleBegin( it )
    {

      _.assert( will.currentModule === null );
      _.assert( will.currentPath === null );

      will.currentModule = it.currentModule;
      will.currentPath = it.currentPath || null;

      if( will.verbosity > 1 )
      {
        // debugger;
        logger.log( '\n', _.color.strFormat( 'Module at', { fg : 'bright white' } ), _.color.strFormat( it.currentModule.commonPath, 'path' ) );
        if( will.currentPath )
        logger.log( _.color.strFormat( '       at', { fg : 'bright white' } ), _.color.strFormat( will.currentPath, 'path' ) );
      }

      return null;
    }

    /* */

    function handleEnd( it )
    {

      logger.up();

      let r = ca.commandPerform
      ({
        command : isolated.secondCommand,
      });
      _.assert( r !== undefined );
      r = _.Consequence.From( r );

      return r.finally( ( err, arg ) =>
      {
        logger.down();

        _.assert( will.currentModule === it.currentModule );
        will.currentModule.finit();
        will.currentModule = null;
        will.currentPath = null;

        if( err )
        _.errLogOnce( _.errBriefly( err ) );
        if( err )
        throw _.err( err );
        return arg;
      });

    }

  }

}

_commandEach_functor.defaults =
{
  filtering : 'all',
}

//

let commandEach = _commandEach_functor({ filtering : 'all' });

// --
// relations
// --

let currentModuleSymbol = Symbol.for( 'currentModule' );

let Composes =
{
  beeping : 0,
}

let Aggregates =
{
}

let Associates =
{
  currentModule : null,
  currentPath : null,
}

let Restricts =
{
  topCommand : null,
}

let Statics =
{
  Exec : Exec,
}

let Forbids =
{
}

let Accessors =
{

  currentModule : { setter : currentModuleSet },

}

// --
// declare
// --

let Extend =
{

  // exec

  Exec,
  exec,

  _moduleReadyThen,
  moduleReadyThen,
  moduleReadyThenNonForming,
  moduleDone,
  errTooMany,
  currentModuleSet,

  commandsMake,
  commandHelp,
  commandSet,

  _commandList,
  commandResourcesList,
  commandPathsList,
  commandSubmodulesList,
  commandReflectorsList,
  commandStepsList,
  commandBuildsList,
  commandExportsList,
  commandAboutList,

  commandSubmodulesClean,
  commandSubmodulesDownload,
  commandSubmodulesUpdate,
  commandSubmodulesFixate,
  commandSubmodulesUpgrade,

  commandShell,
  commandClean,
  commandBuild,
  commandExport,

  commandWith,
  commandEach,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classExtend
({
  cls : Self,
  extend : Extend,
});

//_.EventHandler.mixin( Self );
//_.Instancing.mixin( Self );
//_.StateStorage.mixin( Self );
//_.StateSession.mixin( Self );
//_.CommandsConfig.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
wTools[ Self.shortName ] = Self;

if( !module.parent )
Self.Exec();

})();
