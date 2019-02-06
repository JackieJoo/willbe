( function _Will_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );;
  _.include( 'wExternalFundamentals' );
  _.include( 'wFiles' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function onSuiteBegin()
{
  let self = this;
  // debugger;
  self.tempDir = _.path.dirTempOpen( _.path.join( __dirname, '../..'  ), 'Will' );
  self.assetDirPath = _.path.join( __dirname, 'asset' );
  // debugger;
}

function onSuiteEnd()
{
  let self = this;
  debugger;
  _.assert( _.strHas( self.tempDir, '/dwtools/tmp.tmp' ) )
  _.fileProvider.filesDelete( self.tempDir );
}

/*

  .help - Get help.
  .list - List information about the current module.
  .paths.list - List paths of the current module.
  .submodules.list - List submodules of the current module.
  .reflectors.list - List avaialable reflectors.
  .steps.list - List avaialable steps.
  .builds.list - List avaialable builds.
  .exports.list - List avaialable exports.
  .about.list - List descriptive information about the module.
  .execution.list - List execution scenarios.
  .submodules.download - Download each submodule if such was not downloaded so far.
  .submodules.upgrade - Upgrade each submodule, checking for available updates for such.
  .submodules.clean - Delete all downloaded submodules.
  .clean - Clean current module. Delete genrated artifacts, temp files and downloaded submodules.
  .clean.what - Find out which files will be deleted by clean command.
  .build - Build current module with spesified criterion.
  .export - Export selected the module with spesified criterion. Save output to output file and archive.
  .with - Use "with" to select a module.
  .each - Use "each" to iterate each module in a directory.

*/

//

function singleModuleSimplest( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'single' );
  let dirPath = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  .thenKeep( () =>
  {
    test.case = 'simple run without args'
    return shell()
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  return ready;
}

singleModuleSimplest.timeOut = 130000;

//

function singleModuleList( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'single' );
  let dirPath = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = 'list'
    return shell({ args : [ '.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `name : 'single'` ) );
      test.is( _.strHas( got.output, `description : 'Module for testing'` ) );
      test.is( _.strHas( got.output, `version : '0.0.1'` ) );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'module info'
    return shell({ args : [ '.paths.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `proto : './proto'` ) );
      test.is( _.strHas( got.output, `in : '.'` ) );
      test.is( _.strHas( got.output, `out : 'out'` ) );
      test.is( _.strHas( got.output, `out.debug : './out.debug'` ) );
      test.is( _.strHas( got.output, `out.release : './out.release'` ) );
      return null;
    })
  })



  .thenKeep( () =>
  {
    test.case = 'submodules list'
    return shell({ args : [ '.submodules.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'reflectors.list'
    return shell({ args : [ '.reflectors.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'reflector::reflect.proto.' ) );
      test.is( _.strHas( got.output, `./proto : './out.release'` ) );
      test.is( _.strHas( got.output, `reflector::reflect.proto.debug` ) );
      test.is( _.strHas( got.output, ` ./proto : './out.debug'` ) );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'steps.list'
    return shell({ args : [ '.steps.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'step::reflect.proto.' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.debug' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.raw' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.debug.raw' ))
      test.is( _.strHas( got.output, 'step::export.proto' ))

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.builds.list'
    return shell({ args : [ '.builds.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'build::debug.compiled' ));
      test.is( _.strHas( got.output, 'build::release.raw' ));
      test.is( _.strHas( got.output, 'build::release.compiled' ));
      test.is( _.strHas( got.output, 'build::all' ));

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.exports.list'
    return shell({ args : [ '.exports.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::proto.export' ));
      test.is( _.strHas( got.output, 'steps : ' ));
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'step::export.proto' ));

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.about.list'
    return shell({ args : [ '.about.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );

      test.is( _.strHas( got.output, `name : 'single'` ));
      test.is( _.strHas( got.output, `description : 'Module for testing'` ));
      test.is( _.strHas( got.output, `version : '0.0.1'` ));
      test.is( _.strHas( got.output, `enabled : 1` ));
      test.is( _.strHas( got.output, `interpreters :` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `'chrome >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'firefox >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `keywords :` ));
      test.is( _.strHas( got.output, `'wTools'` ));

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.execution.list'
    return shell({ args : [ '.execution.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  return ready;
}

singleModuleList.timeOut = 130000;

//

function singleModuleSubmodules( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'single' );
  let dirPath = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = '.submodules.download'
    return shell({ args : [ '.submodules.download' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '0/0 submodule(s) of module::single were downloaded in' ) );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.submodules.download'
    return shell({ args : [ '.submodules.download' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '0/0 submodule(s) of module::single were downloaded in' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.submodules.upgrade'
    return shell({ args : [ '.submodules.upgrade' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '0/0 submodule(s) of module::single were upgraded in' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.submodules.clean';
    return shell({ args : [ '.submodules.clean' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Clean deleted 0 file(s) in' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )
      return null;
    })
  })

  return ready;

}

singleModuleSubmodules.timeOut = 130000;

//

function singleModuleClean( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'single' );
  let dirPath = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = '.clean '
    return _.shell
    ({
      path : 'node ' + willExecPath,
      currentPath : dirPath,
      outputCollecting : 1,
      args : [ '.build' ]
    })
    .thenKeep( () =>
    {
      return shell({ args : [ '.clean' ] })
      .thenKeep( ( got ) =>
      {
        test.identical( got.exitCode, 0 );
        test.is( _.strHas( got.output, 'Clean deleted 0 file(s) in' ) );
        test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) )
        test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )
        return null;
      })
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.clean.what '
    return _.shell
    ({
      path : 'node ' + willExecPath,
      currentPath : dirPath,
      outputCollecting : 1,
      args : [ '.build' ]
    })
    .thenKeep( () =>
    {
      return shell({ args : [ '.clean.what' ] })
      .thenKeep( ( got ) =>
      {
        test.identical( got.exitCode, 0 );
        test.is( _.strHas( got.output, 'Clean will delete 0 file(s)' ) );
        return null;
      })
    })
  })

  return ready;

}

singleModuleClean.timeOut = 130000;

//

function singleModuleBuild( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'single' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = '.build'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );
    return shell({ args : [ '.build' ] })
    .thenKeep( ( got ) =>
    {
      debugger;
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Building debug.raw' ) );
      test.is( _.strHas( got.output, 'reflected 2 files' ) );
      test.is( _.strHas( got.output, 'Built debug.raw in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.build debug.raw'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );
    return shell({ args : [ '.build debug.raw' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Building debug.raw' ) );
      test.is( _.strHas( got.output, 'reflected 2 files' ) );
      test.is( _.strHas( got.output, 'Built debug.raw in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.build release.raw'
    let buildOutPath = _.path.join( dirPath, 'out.release' );
    _.fileProvider.filesDelete( buildOutPath );
    return shell({ args : [ '.build release.raw' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Building release.raw' ) );
      test.is( _.strHas( got.output, 'reflected 2 files' ) );
      test.is( _.strHas( got.output, 'Built release.raw in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.build wrong'
    let buildOutDebugPath = _.path.join( dirPath, 'out.debug' );
    let buildOutReleasePath = _.path.join( dirPath, 'out.release' );
    _.fileProvider.filesDelete( buildOutDebugPath );
    _.fileProvider.filesDelete( buildOutReleasePath );
    var o =
    {
      path : 'node ' + willExecPath,
      currentPath : dirPath,
      outputCollecting : 1,
      args : [ '.build wrong' ],
    }
    return test.shouldThrowError( _.shell( o ) )
    .thenKeep( ( got ) =>
    {
      test.is( o.exitCode !== 0 );
      test.is( o.output.length );
      test.is( !_.fileProvider.fileExists( buildOutDebugPath ) )
      test.is( !_.fileProvider.fileExists( buildOutReleasePath ) )

      return null;
    })
  })

  /* - */

  return ready;
}

singleModuleBuild.timeOut = 130000;

//

function singleModuleExport( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'single' );
  let dirPath = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let buildOutPath = _.path.join( dirPath, 'out.debug' );
  _.fileProvider.filesDelete( buildOutPath );

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = '.export'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    let exportPath = _.path.join( dirPath, 'out' );
    _.fileProvider.filesDelete( buildOutPath );
    _.fileProvider.filesDelete( exportPath );
    return shell({ args : [ '.export' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'reflected 2 files' ) );
      test.is( _.strHas( got.output, '+ Write out file' ) );
      test.is( _.strHas( got.output, 'Exported proto.export with 2 files in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );
      var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './single.out.will.yml' ] );

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.export.proto'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    let exportPath = _.path.join( dirPath, 'out' );
    _.fileProvider.filesDelete( buildOutPath );
    _.fileProvider.filesDelete( exportPath );
    return shell({ args : [ '.export proto.export' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Exporting proto.export' ) );
      test.is( _.strHas( got.output, 'reflected 2 files' ) );
      test.is( _.strHas( got.output, 'Exported proto.export with 2 files' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );
      var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './single.out.will.yml' ] );

      return null;
    })
  })


  return ready;
}

singleModuleExport.timeOut = 130000;

//

function withSubmodulesSimplest( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'submodules' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  .thenKeep( () =>
  {
    test.case = 'module info'
    return shell({ args : [ '.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `name : 'withSubmodules'` ) );
      test.is( _.strHas( got.output, `description : 'Module for testing'` ) );
      test.is( _.strHas( got.output, `version : '0.0.1'` ) );
      return null;
    })
  })

  return ready;
}

withSubmodulesSimplest.timeOut = 200000;

//

function withSubmodulesList( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'submodules' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = 'submodules list'
    return shell({ args : [ '.submodules.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'submodule::Tools' ) );
      test.is( _.strHas( got.output, 'submodule::PathFundamentals' ) );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'reflectors.list'
    return shell({ args : [ '.reflectors.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'reflector::reflect.proto.' ))
      test.is( _.strHas( got.output, `reflector::reflect.proto.debug` ))
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'steps.list'
    return shell({ args : [ '.steps.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'step::reflect.proto.' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.debug' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.raw' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.debug.raw' ))
      test.is( _.strHas( got.output, 'step::export.proto' ))

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.builds.list'
    return shell({ args : [ '.builds.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'build::debug.compiled' ));
      test.is( _.strHas( got.output, 'build::release.raw' ));
      test.is( _.strHas( got.output, 'build::release.compiled' ));
      test.is( _.strHas( got.output, 'build::all' ));

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.exports.list'
    return shell({ args : [ '.exports.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::proto.export' ));
      test.is( _.strHas( got.output, 'steps : ' ));
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'step::export.proto' ));

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.about.list'
    return shell({ args : [ '.about.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );

      test.is( _.strHas( got.output, `name : 'withSubmodules'` ));
      test.is( _.strHas( got.output, `description : 'Module for testing'` ));
      test.is( _.strHas( got.output, `version : '0.0.1'` ));
      test.is( _.strHas( got.output, `enabled : 1` ));
      test.is( _.strHas( got.output, `interpreters :` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `'chrome >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'firefox >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `keywords :` ));
      test.is( _.strHas( got.output, `'wTools'` ));

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.execution.list'
    return shell({ args : [ '.execution.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  return ready;
}

withSubmodulesList.timeOut = 130000;

//

function withSubmodulesDownload( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'submodules' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let ready = new _.Consequence().take( null )
  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    ready : ready,
  })

  /* */

  ready

  /* */

  .thenKeep( () =>
  {
    test.case = '.submodules.download - first time';
    _.fileProvider.filesDelete( modulesPath );
    return null;
  })

  shell({ args : [ '.submodules.download' ] })
  .thenKeep( ( got ) =>
  {
    test.identical( got.exitCode, 0 ); debugger;
    test.is( _.strHas( got.output, '2/2 submodule(s) of module::withSubmodules were downloaded in' ) );

    var files = _.fileProvider.filesFind({ filePath : modulesPath, recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
    return null;
  })

  /* */

  .thenKeep( () =>
  {
    test.case = '.submodules.download - again';
    return null;
  })
  shell({ args : [ '.submodules.download' ] })
  .thenKeep( ( got ) =>
  {

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, '0/2 submodule(s) of module::withSubmodules were downloaded in' ) );
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'Tools' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'PathFundamentals' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    return null;
  })

  /* */

  .thenKeep( () =>
  {
    test.case = '.submodules.upgrade - first time';
    _.fileProvider.filesDelete( modulesPath );
    return null;
  })
  shell({ args : [ '.submodules.upgrade' ] })
  .thenKeep( ( got ) =>
  {

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, '2/2 submodule(s) of module::withSubmodules were upgraded in' ) );
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'Tools' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'PathFundamentals' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    return null;
  })

  /* */

  .thenKeep( () =>
  {
    test.case = '.submodules.upgrade - again';
    return null;
  })
  shell({ args : [ '.submodules.upgrade' ] })
  .thenKeep( ( got ) =>
  {

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, '0/2 submodule(s) of module::withSubmodules were upgraded in' ) );
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'Tools' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'PathFundamentals' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    return null;
  })

  /* */

  var files;

  ready
  .thenKeep( () =>
  {
    test.case = '.submodules.clean';

    files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1
    });

    return files;
  })

  shell({ args : [ '.submodules.clean' ] })

  .thenKeep( ( got ) =>
  {

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, `${files.length}` ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) ); /* xxx : phantom problem ? */
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );

    return null;
  })

  /* */

  return ready;
}

withSubmodulesDownload.timeOut = 130000;

//

function withSubmodulesClean( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'submodules' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let ready = new _.Consequence().take( null );
  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    ready : ready,
  })

  /* - */

  shell
  ({
    args : [ '.submodules.upgrade' ],
  })

  /* - */

  .thenKeep( ( got ) =>
  {
    test.case = '.clean ';
    test.is( _.strHas( got.output, '2/2 submodule(s) of module::withSubmodules were upgraded in' ) );

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1
    })

    test.is( files.length > 100 );

    return null;
  })

  shell
  ({
    args : [ '.build' ],
  })
  .thenKeep( ( got ) =>
  {
    test.is( _.strHas( got.output, '0/2 submodule(s) of module::withSubmodules were downloaded in' ) );
    return got;
  })

  /* - */

  shell({ args : [ '.clean.what' ] })

  .thenKeep( ( got ) =>
  {
    test.case = '.clean.what';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1,
      allowingMissed : 0,
    });

    test.is( files.length > 100 );

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, String( files.length ) ) );
    test.is( _.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );

    return null;
  })

  /* - */

  shell
  ({
    args : [ '.build' ]
  })

  shell({ args : [ '.clean' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.clean';
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Clean deleted' ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) ); /* filesDelete issue? */
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );
    return null;
  })

  /* */

  shell({ args : [ '.submodules.upgrade' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.submodules.upgrade'
    test.identical( got.exitCode, 0 );
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
    test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) )

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'Tools' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'PathFundamentals' ), recursive : 2, outputFormat : 'relative' })
    test.is( files.length );

    return null;
  })

  /* */

  var files;
  ready
  .thenKeep( () =>
  {

    files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1
    });

    return null;
  })

  /* */

  shell({ args : [ '.submodules.clean' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.submodules.clean';
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, `${files.length}` ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) ); /* xxx : phantom problem ? */
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );
    return null;
  })

  /* - */

  return ready;
}

withSubmodulesClean.timeOut = 130000;

//

function withSubmodulesBuild( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'submodules' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let ready = new _.Consequence().take( null );
  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    ready : ready,
  })

  ready

  /* - */

  .thenKeep( () =>
  {
    test.case = 'build withoud submodules'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );
    return null;
  })

  shell({ args : [ '.build' ] })
  .finally( ( err, got ) =>
  {
    test.is( !err );
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    var files = _.fileProvider.dirRead( buildOutPath );
    debugger;
    test.identical( files.length, 2 );
    return null;
  })

  /* - */

  shell({ args : [ '.submodules.upgrade' ] })
  .thenKeep( () =>
  {
    test.case = '.build'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );
    return null;
  })

  shell({ args : [ '.build' ] })
  .thenKeep( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.is( _.strHas( got.output, 'Building debug.raw' ) );
    test.is( _.strHas( got.output, 'Built debug.raw in' ) );

    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    var files = _.fileProvider.filesFind
    ({
      filePath : buildOutPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1,
    });

    test.is( files.length > 10 );

    return null;
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.build wrong'
    let buildOutDebugPath = _.path.join( dirPath, 'out.debug' );
    let buildOutReleasePath = _.path.join( dirPath, 'out.release' );
    _.fileProvider.filesDelete( buildOutDebugPath );
    _.fileProvider.filesDelete( buildOutReleasePath );
    return null;
  })

  .thenKeep( () =>
  {

    var o =
    {
      path : 'node ' + willExecPath,
      currentPath : dirPath,
      outputCollecting : 1,
      args : [ '.build wrong' ]
    }

    let buildOutDebugPath = _.path.join( dirPath, 'out.debug' );
    let buildOutReleasePath = _.path.join( dirPath, 'out.release' );

    return test.shouldThrowError( _.shell( o ) )
    .thenKeep( ( got ) =>
    {
      test.is( o.exitCode !== 0 );
      test.is( o.output.length );
      test.is( !_.fileProvider.fileExists( buildOutDebugPath ) )
      test.is( !_.fileProvider.fileExists( buildOutReleasePath ) )

      return null;
    })

  });

  return ready;
}

withSubmodulesBuild.timeOut = 130000;

//

function withSubmodulesExport( test )
{
  let self = this;

  let originalDirPath = _.path.join( self.assetDirPath, 'submodules' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = '.export'
    let buildOutPath = _.path.join( dirPath, 'out.debug' );
    let exportPath = _.path.join( dirPath, 'out' );
    _.fileProvider.filesDelete( buildOutPath );
    _.fileProvider.filesDelete( exportPath );
    return shell({ args : [ '.export' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Exporting proto.export' ) );

      var files = _.fileProvider.filesFind
      ({
        filePath : buildOutPath,
        recursive : 2,
        includingDirs : 1,
        includingTerminals : 1,
        includingTransient : 1,
      });
      test.is( files.length > 10 );

      var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
      test.identical( files, [ './withSubmodules.out.will.yml' ] );

      return null;
    })
  })

  return ready;
}

withSubmodulesExport.timeOut = 130000;

//

function submodulesDownload( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'submodules-download' );
  let dirPath = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath }  })
  _.fileProvider.filesDelete( _.path.join( dirPath, '.module' ) );
  _.fileProvider.filesDelete( _.path.join( dirPath, 'out.debug' ) );

  let willExecPath = _.path.nativize( _.path.join( __dirname, '../will/Exec2' ) );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    verbosity : 3,
  })

  let ready = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = 'simple run without args'
    return shell()
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'list'
    return shell({ args : [ '.list' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      debugger;
      test.is( _.strHas( got.output, `git+https:///github.com/Wandalen/wTools.git/out/wTools#master` ) );
      debugger;
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'build'
    _.fileProvider.filesDelete( _.path.join( dirPath, '.module' ) );
    _.fileProvider.filesDelete( _.path.join( dirPath, 'out.debug' ) );
    return shell({ args : [ '.build' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.gt( _.fileProvider.dirRead( _.path.join( dirPath, '.module/Tools' ) ).length, 0 );
      test.gt( _.fileProvider.dirRead( _.path.join( dirPath, 'out.debug' ) ).length, 0 );
      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = 'export'
    _.fileProvider.filesDelete( _.path.join( dirPath, '.module' ) );
    _.fileProvider.filesDelete( _.path.join( dirPath, 'out.debug' ) );
    _.fileProvider.filesDelete( _.path.join( dirPath, 'out/Download.out.will.yml' ) );
    return shell({ args : [ '.export' ] })
    .thenKeep( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.gt( _.fileProvider.dirRead( _.path.join( dirPath, '.module/Tools' ) ).length, 0 );
      test.gt( _.fileProvider.dirRead( _.path.join( dirPath, 'out.debug' ) ).length, 0 );
      test.is( _.fileProvider.isTerminal( _.path.join( dirPath, 'out/Download.out.will.yml' ) ) );
      return null;
    })
  })

  /* - */

  return ready;
}

submodulesDownload.timeOut = 130000;

//

function submodulesBrokenClean1( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'submodules-broken-1' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );
  let exportPath = _.path.join( dirPath, 'out' );
  let buildOutPath = _.path.join( dirPath, 'out.debug' );

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  test.description = 'should handle currputed will-file properly';

  let ready = new _.Consequence().take( null );
  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    ready : ready,
  })

  /* - */

  _.fileProvider.filesDelete( dirPath );
  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });

  ready

  /* - */

  .thenKeep( ( got ) =>
  {
    test.case = '.clean ';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1
    })

    test.identical( files.length, 4 );

    return null;
  })

  /* - */

  shell({ args : [ '.clean.what' ] })

  .thenKeep( ( got ) =>
  {
    test.case = '.clean.what';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1,
      allowingMissed : 0,
    });

    test.identical( files.length, 4 );

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, String( files.length ) ) );
    test.is( _.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );

    return null;
  })

  /* - */

  shell({ args : [ '.clean' ] })

  .thenKeep( ( got ) =>
  {
    test.case = '.clean';
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Clean deleted' ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) ); /* filesDelete issue? */
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );
    return null;
  })

  /* */

  shell({ args : [ '.export' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.export';

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Exporting proto.export' ) );

    var files = _.fileProvider.filesFind
    ({
      filePath : buildOutPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1,
    });
    test.is( files.length > 10 );

    var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
    test.identical( files, [ './withSubmodules.out.will.yml' ] );

    return null;
  })

  /* - */

  ready
  .thenKeep( ( got ) =>
  {

    _.fileProvider.filesDelete( dirPath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });

    return null;
  });

  /* */

  shell({ args : [ '.export' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.export';

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Exporting proto.export' ) );

    var files = _.fileProvider.filesFind
    ({
      filePath : buildOutPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1,
    });
    test.is( files.length > 10 );

    var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
    test.identical( files, [ './withSubmodules.out.will.yml' ] );

    return null;
  })

  /* - */

  return ready;
}

submodulesBrokenClean1.timeOut = 130000;

//

function submodulesBrokenClean2( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'submodules-broken-2' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );
  let exportPath = _.path.join( dirPath, 'out' );
  let buildOutPath = _.path.join( dirPath, 'out.debug' );

  test.description = 'should handle currputed will-file properly';

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let ready = new _.Consequence().take( null );
  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    ready : ready,
  })

  /* - */

  _.fileProvider.filesDelete( dirPath );
  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });

  ready

  /* - */

  .thenKeep( ( got ) =>
  {
    test.case = '.clean ';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1
    })

    test.identical( files.length, 4 );

    return null;
  })

  /* - */

  shell({ args : [ '.clean.what' ] })

  .thenKeep( ( got ) =>
  {
    test.case = '.clean.what';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : 2,
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1,
      allowingMissed : 0,
    });

    test.identical( files.length, 4 );

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, String( files.length ) ) );
    test.is( _.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );

    return null;
  })

  /* - */

  shell({ args : [ '.clean' ] })

  .thenKeep( ( got ) =>
  {
    test.case = '.clean';
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Clean deleted' ) );
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, '.module' ) ) ); /* filesDelete issue? */
    test.is( !_.fileProvider.fileExists( _.path.join( dirPath, 'modules' ) ) );
    return null;
  })

  /* */

  shell({ args : [ '.export' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.export';

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Exporting proto.export' ) );

    var files = _.fileProvider.filesFind
    ({
      filePath : buildOutPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1,
    });
    test.is( files.length > 10 );

    var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
    test.identical( files, [ './withSubmodules.out.will.yml' ] );

    return null;
  })

  /* - */

  ready
  .thenKeep( ( got ) =>
  {

    _.fileProvider.filesDelete( dirPath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });

    return null;
  });

  /* */

  shell({ args : [ '.export' ] })
  .thenKeep( ( got ) =>
  {
    test.case = '.export';

    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, 'Exporting proto.export' ) );

    var files = _.fileProvider.filesFind
    ({
      filePath : buildOutPath,
      recursive : 2,
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1,
    });
    test.is( files.length > 10 );

    var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : 2, outputFormat : 'relative' })
    test.identical( files, [ './withSubmodules.out.will.yml' ] );

    return null;
  })

  /* - */

  return ready;
}

submodulesBrokenClean2.timeOut = 130000;

//

function multipleExports( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'multiple-exports' );
  let dirPath = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( dirPath, '.module' );
  let exportPath = _.path.join( dirPath, 'out' );
  let outWillPath = _.path.join( exportPath, 'multiple-exports.out.will.yml' );
  // let buildOutPath = _.path.join( dirPath, 'out.debug' );

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let ready = new _.Consequence().take( null );
  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : dirPath,
    outputCollecting : 1,
    ready : ready,
  })

  let find = _.fileProvider.filesFinder
  ({
    recursive : 2,
    includingTerminals : 1,
    includingDirs : 1,
    includingTransient : 1,
    allowingMissed : 0,
    outputFormat : 'relative',
  });

  /* - */

  ready
  .thenKeep( ( got ) =>
  {
    test.case = '.export debug:1';

    _.fileProvider.filesDelete( dirPath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });
    _.fileProvider.filesDelete( exportPath );

    return null;
  })

  shell({ args : [ '.export debug:1' ] })

  .thenKeep( ( got ) =>
  {

    var files = find( exportPath );
    test.identical( files, [ '.', './multiple-exports.debug.out.tgs', './multiple-exports.out.will.yml' ] );
    test.identical( got.exitCode, 0 );

    test.is( _.strHas( got.output, String( files.length ) ) );
    test.is( _.strHas( got.output, 'Read 2 will-files in' ) );
    test.is( _.strHas( got.output, 'Exported export.debug in' ) );
    test.is( _.strHas( got.output, 'Write out archive' ) );
    test.is( _.strHas( got.output, 'Write out will-file' ) );
    test.is( _.strHas( got.output, 'multiple-exports.debug.out.tgs' ) );
    test.is( _.strHas( got.output, 'out/multiple-exports.out.will.yml' ) );

    var outfile = _.fileProvider.fileConfigRead( outWillPath );
    var exported =
    {
      'export.debug' :
      {
        version : '0.0.1',
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        },
        exportedReflector : 'reflector::exported.export.debug',
        exportedFilesReflector : 'reflector::exportedFiles.export.debug',
        exportedDirPath : 'path::exportedDir.export.debug',
        exportedFilesPath : 'path::exportedFiles.export.debug',
        archiveFilePath : 'path::archiveFile.export.debug'
      }
    }

    test.identical( outfile.exported, exported );

    var exportedReflector =
    {
      srcFilter : { filePath : { './out.debug' : true }, prefixPath : '.' },
      criterion :
      {
        default : 1,
        debug : 1,
        raw : 1,
        export : 1
      }
    }
    test.identical( outfile.reflector[ 'exported.export.debug' ], exportedReflector );

    var exportedReflectorFiles =
    {
      recursive : 0,
      srcFilter :
      {
        filePath : { '.' : true, './File.debug.js' : true },
        basePath : '.',
        prefixPath : 'out.debug'
      },
      criterion :
      {
        default : 1,
        debug : 1,
        raw : 1,
        export : 1
      }
    }

    test.identical( outfile.reflector[ 'exportedFiles.export.debug' ], exportedReflectorFiles );

    let outfilePath =
    {
      proto : { path : './proto' },
      in : { path : '.' },
      out : { path : 'out' },
      'out.debug' :
      {
        path : './out.debug',
        criterion : { debug : 1 }
      },
      'out.release' :
      {
        path : './out.release',
        criterion : { debug : 0 }
      },
      'exportedDir.export.debug' :
      {
        path : './out.debug',
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        }
      },
      'exportedFiles.export.debug' :
      {
        path : [ '.', './File.debug.js' ],
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        }
      },
      'archiveFile.export.debug' :
      {
        path : './out/multiple-exports.debug.out.tgs',
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        }
      }
    }

    test.identical( outfile.path, outfilePath );

    return null;
  })

  /* - */

  ready
  .thenKeep( ( got ) =>
  {
    test.case = '.export debug:1';

    _.fileProvider.filesDelete( dirPath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : dirPath } });
    _.fileProvider.filesDelete( exportPath );

    return null;
  })

  shell({ args : [ '.export debug:1' ] })
  shell({ args : [ '.export debug:0' ] })
  shell({ args : [ '.export debug:0' ] })

  .thenKeep( ( got ) =>
  {

    var files = find( exportPath );
    test.identical( files, [ '.', './multiple-exports.debug.out.tgs', './multiple-exports.out.tgs', './multiple-exports.out.will.yml' ] );
    test.identical( got.exitCode, 0 );

    test.is( _.strHas( got.output, String( files.length ) ) );
    test.is( _.strHas( got.output, 'Read 2 will-files in' ) );
    test.is( _.strHas( got.output, 'Exported export. in' ) );
    test.is( _.strHas( got.output, 'Write out archive' ) );
    test.is( _.strHas( got.output, 'Write out will-file' ) );
    test.is( _.strHas( got.output, 'multiple-exports.out.tgs' ) );
    test.is( _.strHas( got.output, 'out/multiple-exports.out.will.yml' ) );

    var outfile = _.fileProvider.fileConfigRead( outWillPath );
    var exported =
    {
      'export.debug' :
      {
        version : '0.0.1',
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        },
        exportedReflector : 'reflector::exported.export.debug',
        exportedFilesReflector : 'reflector::exportedFiles.export.debug',
        exportedDirPath : 'path::exportedDir.export.debug',
        exportedFilesPath : 'path::exportedFiles.export.debug',
        archiveFilePath : 'path::archiveFile.export.debug'
      },
      'export.' :
      {
        version : '0.0.1',
        criterion :
        {
          default : 1,
          debug : 0,
          raw : 1,
          export : 1
        },
        exportedReflector : 'reflector::exported.export.',
        exportedFilesReflector : 'reflector::exportedFiles.export.',
        exportedDirPath : 'path::exportedDir.export.',
        exportedFilesPath : 'path::exportedFiles.export.',
        archiveFilePath : 'path::archiveFile.export.'
      },
    }

    test.identical( outfile.exported, exported );

    var exportedReflector =
    {
      srcFilter : { filePath : { './out.debug' : true }, prefixPath : '.' },
      criterion :
      {
        default : 1,
        debug : 1,
        raw : 1,
        export : 1
      }
    }
    test.identical( outfile.reflector[ 'exported.export.debug' ], exportedReflector );

    var exportedReflector =
    {
      srcFilter : { filePath : { './out.release' : true }, prefixPath : '.' },
      criterion :
      {
        default : 1,
        debug : 0,
        raw : 1,
        export : 1
      }
    }
    test.identical( outfile.reflector[ 'exported.export.' ], exportedReflector );

    var exportedReflectorFiles =
    {
      recursive : 0,
      srcFilter :
      {
        filePath : { '.' : true, './File.debug.js' : true },
        basePath : '.',
        prefixPath : 'out.debug'
      },
      criterion :
      {
        default : 1,
        debug : 1,
        raw : 1,
        export : 1
      }
    }

    test.identical( outfile.reflector[ 'exportedFiles.export.debug' ], exportedReflectorFiles );

    var exportedReflectorFiles =
    {
      recursive : 0,
      srcFilter :
      {
        filePath : { '.' : true, './File.release.js' : true },
        basePath : '.',
        prefixPath : 'out.release'
      },
      criterion :
      {
        default : 1,
        debug : 0,
        raw : 1,
        export : 1
      }
    }

    test.identical( outfile.reflector[ 'exportedFiles.export.' ], exportedReflectorFiles );

    let outfilePath =
    {
      proto : { path : './proto' },
      in : { path : '.' },
      out : { path : 'out' },
      'out.debug' :
      {
        path : './out.debug',
        criterion : { debug : 1 }
      },
      'out.release' :
      {
        path : './out.release',
        criterion : { debug : 0 }
      },
      'exportedDir.export.debug' :
      {
        path : './out.debug',
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        }
      },
      'exportedFiles.export.debug' :
      {
        path : [ '.', './File.debug.js' ],
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        }
      },
      'archiveFile.export.debug' :
      {
        path : './out/multiple-exports.debug.out.tgs',
        criterion :
        {
          default : 1,
          debug : 1,
          raw : 1,
          export : 1
        }
      },
      'exportedDir.export.' :
      {
        path : './out.release',
        criterion :
        {
          default : 1,
          debug : 0,
          raw : 1,
          export : 1
        }
      },
      'exportedFiles.export.' :
      {
        path : [ '.', './File.release.js' ],
        criterion :
        {
          default : 1,
          debug : 0,
          raw : 1,
          export : 1
        }
      },
      'archiveFile.export.' :
      {
        path : './out/multiple-exports.out.tgs',
        criterion :
        {
          default : 1,
          debug : 0,
          raw : 1,
          export : 1
        }
      }
    }

    test.identical( outfile.path, outfilePath );

    debugger;
    return null;
  })

  /* - */

  return ready;
}

multipleExports.timeOut = 130000;

//

var Self =
{

  name : 'Tools/atop/Will',
  silencing : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  context :
  {
    tempDir : null,
    assetDirPath : null
  },

  tests :
  {

    singleModuleSimplest,
    singleModuleList,
    singleModuleSubmodules,
    singleModuleClean,
    singleModuleBuild,
    singleModuleExport,

    withSubmodulesSimplest,
    withSubmodulesList,
    withSubmodulesDownload,
    withSubmodulesClean,
    withSubmodulesBuild,
    withSubmodulesExport,

    submodulesDownload,

    submodulesBrokenClean1,
    submodulesBrokenClean2,

    multipleExports,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})( );
