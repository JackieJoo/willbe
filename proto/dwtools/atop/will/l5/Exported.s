( function _Exported_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

let Tar;

//

let _ = wTools;
let Parent = _.Will.Inheritable;
let Self = function wWillExported( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Exported';

// --
// inter
// --

//

function build()
{
  let exported = this;
  let module = exported.module;
  let will = module.will;
  let build = module.buildMap[ exported.name ];
  let fileProvider = will.fileProvider;
  let path = fileProvider.path;
  let logger = will.logger;
  let hub = will.fileProvider;
  let hd = hub.providersWithProtocolMap.file;

  let exportedDirPath = build.exportedDirPathFor();
  let archiveFilePath = build.archiveFilePathFor();
  let outFilePath = build.outFilePathFor();
  let outDirPath = path.dir( outFilePath );

  _.assert( arguments.length === 0 );
  _.assert( !!module );
  _.assert( !!will );
  _.assert( !!hd );
  _.assert( !!logger );
  _.assert( !!build );
  // _.assert( !outf.formed );
  _.assert( module.formed === 2 );
  _.assert( will.formed === 1 );
  _.assert( build.formed === 3 );
  // _.assert( outf.data === null );
  // _.assert( module.exported === null );
  _.assert( exported.criterion === null );

  _.sure( _.strDefined( module.dirPath ), 'Expects directory path of the module' );
  _.sure( _.objectIs( build.criterion ), 'Expects criterion of export' );
  _.sure( _.strDefined( build.name ), 'Expects name of export' );
  _.sure( _.objectIs( module.willFileWithRoleMap.import ) || _.objectIs( module.willFileWithRoleMap.single ), 'Expects import in fine' );
  _.sure( _.objectIs( module.willFileWithRoleMap.export ) || _.objectIs( module.willFileWithRoleMap.single ), 'Expects export in fine' );
  _.sure( _.strDefined( module.about.name ), 'Expects name of the module defined' );
  _.sure( _.strDefined( module.about.version ), 'Expects the current version of the module defined' );
  _.sure( hd.fileExists( exportedDirPath ) );

  /* begin */

  // exported.build();

  exported.criterion = _.mapExtend( null, build.criterion );

  // exported.exportedDirPath = module.pathAllocate( 'exportedDir', path.dot( path.relative( outDirPath, exportedDirPath ) ) );
  exported.exportedDirPath = module.pathAllocate( 'exportedDir', path.dot( path.relative( module.dirPath, exportedDirPath ) ) );
  exported.exportedDirPath.criterion = _.mapExtend( null, exported.criterion );
  exported.exportedDirPath.form();
  exported.exportedDirPath = 'path::' + exported.exportedDirPath.name;

  if( exported.criterion.tar === undefined || exported.criterion.tar )
  {
    // exported.archiveFilePath = module.pathAllocate( 'archiveFile', path.dot( path.relative( outDirPath, archiveFilePath ) ) );
    exported.archiveFilePath = module.pathAllocate( 'archiveFile', path.dot( path.relative( module.dirPath, archiveFilePath ) ) );
    exported.archiveFilePath.criterion = _.mapExtend( null, exported.criterion );
    exported.archiveFilePath.form();
    exported.archiveFilePath = 'path::' + exported.archiveFilePath.name;
  }
  else
  {
    exported.archiveFilePath = null;
  }

  debugger;

  // _.assert( module.pathMap[  ] );
  // exported.exportedDirPath = path.dot( path.relative( outDirPath, exportedDirPath ) );
  // exported.archiveFilePath = path.dot( path.relative( outDirPath, archiveFilePath ) );

  // exported.formatVersion = will.FormatVersion;

  exported.version = module.about.version;
  exported.files = null;

  // outf.data.formatVersion = outf.Version;
  // outf.data.version = module.about.version;
  // outf.data.files = null;

  // outf.data.importIn = module.willFileWithRoleMap.import ? module.willFileWithRoleMap.import.data : null;
  // outf.data.exportIn = module.willFileWithRoleMap.export ? module.willFileWithRoleMap.export.data : null;
  // outf.data.singleIn = module.willFileWithRoleMap.single ? module.willFileWithRoleMap.single.data : null;

  exported.files = hd.filesFind
  ({
    recursive : 1,
    includingDirectories : 1,
    includingTerminals : 1,
    outputFormat : 'relative',
    filePath : exportedDirPath,
    filter :
    {
      maskTransientDirectory : { /*excludeAny : [ /\.git$/, /node_modules$/ ]*/ },
      basePath : exportedDirPath,
    },
  });

  /* */

  // outf.data = module.dataExport();
  let data = module.dataExport();

  hd.fileWrite
  ({
    filePath : outFilePath,
    data : data,
    encoding : 'yaml',
  });

  /* */

  if( will.verbosity >= 2 )
  logger.log( ' + ' + 'Write out file to ' + outFilePath );

  if( exported.criterion.tar === undefined || exported.criterion.tar )
  {

    if( !Tar )
    Tar = require( 'tar' );

    let o2 =
    {
      gzip : true,
      sync : 1,
      file : hd.path.nativize( archiveFilePath ),
      cwd : hd.path.nativize( exportedDirPath ),
    }

    debugger;
    let zip = Tar.create( o2, [ '.' ] );
    debugger;

    if( will.verbosity >= 2 )
    logger.log( ' + ' + 'Write out archive ' + hd.path.move( archiveFilePath, exportedDirPath ) );

  }

}

// --
// relations
// --

let Composes =
{

  version : null,

  exportedDirPath : null,
  archiveFilePath : null,

  description : null,
  criterion : null,

  inherit : _.define.own([]),
  files : null,

}

let Aggregates =
{
  name : null,
}

let Associates =
{
  module : null,
}

let Restricts =
{
}

let Statics =
{
  MapName : 'exportedMap',
  PoolName : 'exported',
}

let Forbids =
{
}

let Accessors =
{
}

// --
// declare
// --

let Proto =
{

  // inter

  build : build,

  // relation

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

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
module[ 'exports' ] = wTools;

_.staticDecalre
({
  prototype : _.Will.prototype,
  name : Self.shortName,
  value : Self,
});

})();
