( function _Path_s_() {

'use strict';

/**
 * Collection of routines to operate paths in the reliable and consistent way. Path leverages parsing,joining,extracting,normalizing,nativizing,resolving paths. Use the module to get uniform experience from playing with paths on different platforms.
  @module Tools/base/Path
*/

/**
 * @file Path.s.
 */

/**
 * @summary Collection of routines to operate paths in the reliable and consistent way.
 * @namespace "wTools.path"
 * @memberof module:Tools/base/Path
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Self = _.path = _.path || Object.create( null );

// --
// internal
// --

function Init()
{

  _.assert( _.strIs( this._rootStr ) );
  _.assert( _.strIs( this._upStr ) );
  _.assert( _.strIs( this._hereStr ) );
  _.assert( _.strIs( this._downStr ) );

  let notBeginning = '(?!^)';

  if( !this._hereUpStr )
  this._hereUpStr = this._hereStr + this._upStr; /* ./ */
  if( !this._downUpStr )
  this._downUpStr = this._downStr + this._upStr; /* ../ */

  this._upEscapedStr = _.regexpEscape( this._upStr );
  this._downEscapedStr = _.regexpEscape( this._downStr );

  this._butDownUpEscapedStr = '(?!' + this._downEscapedStr + this._upEscapedStr + ')';
  this._delDownEscapedStr = this._butDownUpEscapedStr + '(?:(?!' + this._upEscapedStr + ').)*' + this._upEscapedStr + this._downEscapedStr + '(' + this._upEscapedStr + '|$)';
  this._delDownEscapedNonEmptyStr = this._butDownUpEscapedStr + '((?!' + this._upEscapedStr + ').)+' + this._upEscapedStr + this._downEscapedStr + '(' + this._upEscapedStr + '|$)';

  this._delUpRegexp = new RegExp( this._upEscapedStr + '+$' );

  this._delHereRegexp = new RegExp( this._upEscapedStr + _.regexpEscape( this._hereStr ) + '(' + this._upEscapedStr + '|$)' );

  let up = this._upEscapedStr;
  let down = this._downEscapedStr;
  let beginOrChar = '(?:.|^)';
  let butUp = `(?:(?!${up}).)+`;
  // let notDownUp = `(?!${down}${up})`;
  let notDownUp = `(?!${down}(?:${up}|$))`;
  let upOrBegin = `(?:^|${up})`;
  let upOrEnd = `(?:${up}|$)`;
  let splitOrUp = `(?:(?:${up}${up})|((${upOrBegin})${notDownUp}${butUp}${up}))`; /* split or / */

  this._delDownRegexp = new RegExp( `(${beginOrChar})${splitOrUp}${down}(${upOrEnd})`, '' );
  // this._delDownRegexp = new RegExp( notDownUp + upOrBegin + '(' + notDownUp + splitUpDown + ')' + upOrEnd, '' );
  // this._delDownRegexp = new RegExp( '(?:' + this._upEscapedStr + ')?' + this._delDownEscapedStr, '' );

  this._delDownFirstRegexp = new RegExp( '^' + '(' + this._upStr + ')?' + this._delDownEscapedNonEmptyStr, '' );
  this._delDownSecondRegexp = new RegExp( '(?!^)' + '(' + this._upEscapedStr + ')?' + '(' + this._upEscapedStr + ')' + this._delDownEscapedStr, '' ); /* ../ x */

  // this._delDownRegexp2 = new RegExp( '^' + '(' + this._upStr + ')?' + this._delDownEscapedNonEmptyStr, '' );

  this._delUpDupRegexp = /\/{2,}/g;

}

//

function CloneExtending( o )
{
  _.assert( arguments.length === 1 );
  let result = Object.create( this )
  _.mapExtend( result,Parameters,o );
  result.Init();
  return result;
}

//

/*
qqq : use routineVectorize_functor instead
*/

function _pathMultiplicator_functor( o )
{

  if( _.routineIs( o ) || _.strIs( o ) )
  o = { routine : o }

  _.routineOptions( _pathMultiplicator_functor, o );
  _.assert( _.routineIs( o.routine ) );
  _.assert( o.fieldNames === null || _.longIs( o.fieldNames ) )

  /* */

  let routine = o.routine;
  let fieldNames = o.fieldNames;

  function supplement( src,l )
  {
    if( !_.longIs( src ) )
    src = _.arrayFillTimes( [], l,src );
    _.assert( src.length === l, 'routine expects arrays with same length' );
    return src;
  }

  function inputMultiplicator( o )
  {
    let result = [];
    let l = 0;
    let onlyScalars = true;

    if( arguments.length > 1 )
    {
      let args = [].slice.call( arguments );

      for( let i = 0; i < args.length; i++ )
      {
        if( onlyScalars && _.longIs( args[ i ] ) )
        onlyScalars = false;

        l = Math.max( l,_.arrayAs( args[ i ] ).length );
      }

      for( let i = 0; i < args.length; i++ )
      args[ i ] = supplement( args[ i ], l );

      for( let i = 0; i < l; i++ )
      {
        let argsForCall = [];

        for( let j = 0; j < args.length; j++ )
        argsForCall.push( args[ j ][ i ] );

        let r = routine.apply( this,argsForCall );
        result.push( r )
      }
    }
    else
    {
      if( fieldNames === null || !_.objectIs( o ) )
      {
        if( _.longIs( o ) )
        {
          for( let i = 0; i < o.length; i++ )
          result.push( routine.call( this,o[ i ] ) );
        }
        else
        {
          result = routine.call( this,o );
        }

        return result;
      }

      let fields = [];

      for( let i = 0; i < fieldNames.length; i++ )
      {
        let field = o[ fieldNames[ i ] ];

        if( onlyScalars && _.longIs( field ) )
        onlyScalars = false;

        l = Math.max( l,_.arrayAs( field ).length );
        fields.push( field );
      }

      for( let i = 0; i < fields.length; i++ )
      fields[ i ] = supplement( fields[ i ], l );

      for( let i = 0; i < l; i++ )
      {
        let options = _.mapExtend( null,o );
        for( let j = 0; j < fieldNames.length; j++ )
        {
          let fieldName = fieldNames[ j ];
          options[ fieldName ] = fields[ j ][ i ];
        }

        result.push( routine.call( this,options ) );
      }
    }

    _.assert( result.length === l );

    if( onlyScalars )
    return result[ 0 ];

    return result;
  }

  return inputMultiplicator;
}

_pathMultiplicator_functor.defaults =
{
  routine : null,
  fieldNames : null
}

//

function _filterNoInnerArray( arr )
{
  return arr.every( ( e ) => !_.arrayIs( e ) );
}

//

function _filterOnlyPath( e, k, c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Path' ) )
    return true;
    else
    return false
  }
  return this.is( e );
}

// --
// path tester
// --

function is( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.strIs( path );
}

//

function are( paths )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( _.mapIs( paths ) )
  return true;
  if( !_.arrayIs( paths ) )
  return false;
  return paths.every( ( path ) => self.is( path ) );
}

//

function like( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( this.is( path ) )
  return true;
  if( _.FileRecord )
  if( path instanceof _.FileRecord )
  return true;
  return false;
}

//

/**
 * Checks if string is correct possible for current OS path and represent file/directory that is safe for modification
 * (not hidden for example).
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isSafe
 * @memberof module:Tools/base/Path.wTools.path
 */

function isSafe( filePath,level )
{
  filePath = this.normalize( filePath );

  if( level === undefined )
  level = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( level ), 'Expects number {- level -}' );

  if( level >= 1 )
  {
    //let isAbsolute = this.isAbsolute( filePath );
    //if( isAbsolute )
    if( this.isAbsolute( filePath ) )
    {
      // debugger;
      let parts = filePath.split( this._upStr ).filter( ( p ) => p.trim() );
      //let number = parts.lenth;
      if( process.platform === 'win32' && parts.length && parts[ 0 ].length === 1 )
      parts.splice( 0, 1 );
      if( parts.length <= 1 )
      return false;
      if( level >= 2 && parts.length <= 2 )
      return false;
      return true;
    }
  }

  if( level >= 2 && process.platform === 'win32' )
  {
    if( _.strHas( filePath, 'Windows' ) )
    return false;
    if( _.strHas( filePath, 'Program Files' ) )
    return false;
  }

  if( level >= 2 )
  if( /(^|\/)\.(?!$|\/|\.)/.test( filePath ) )
  return false;

  // if( level >= 1 )
  // if( filePath.indexOf( '/' ) === 1 )
  // if( filePath[ 0 ] === '/' )
  // {
  //   throw _.err( 'not tested' );
  //   return false;
  // }

  if( level >= 3 )
  if( /(^|\/)node_modules($|\/)/.test( filePath ) )
  return false;

  // if( safe )
  // safe = filePath.length > 8 || ( filePath[ 0 ] !== '/' && filePath[ 1 ] !== ':' );

  return true;
}

//

/**
 * Checks if string path is refined ( checks that the string doesn´t contain left( \\ ) or double slashes ( // ) ), and it also
 * returns true when the path has slash ( / ) in the end .
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isRefinedMaybeTrailed
 * @memberof module:Tools/base/Path.wTools.path
 */

function isRefinedMaybeTrailed( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string {-path-}, but got', _.strType( path ) );

  // if( !path.length )
  // return false;

  if( path[ 1 ] === ':' && path[ 2 ] === '\\' )
  return false;

  let leftSlash = /\\/g;
  let doubleSlash = /\/\//g;

  if( leftSlash.test( path ) /* || doubleSlash.test( path ) */ )
  return false;

  // if( !_.strEnds( path, this._upStr + this._upStr ) )
  // return false;
  // if( path !== this._upStr && !_.strEnds( path, this._upStr + this._upStr ) && _.strEnds( path, this._upStr ) )
  // return false;

  return true;
}

//

/**
 * Checks if string path is refined: checks that the string doesn´t contain left( \\ ) or double slashes ( // ) ), and that it is not trailed
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isRefined
 * @memberof module:Tools/base/Path.wTools.path
 */

function isRefined( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string {-path-}, but got', _.strType( path ) );

  if( !this.isRefinedMaybeTrailed( path ) )
  return false;

  // if( !_.strEnds( path, this._upStr + this._upStr ) )
  // return false;

  // if( path !== this._upStr && !_.strEnds( path, this._upStr + this._upStr ) && _.strEnds( path, this._upStr ) )
  // return false;

  return true;
}

//

/**
 * Checks if string path is normalized, and maybe trailed ( ends with a slash ( / ) ).
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isNormalizedMaybeTrailed
 * @memberof module:Tools/base/Path.wTools.path
 */

function isNormalizedMaybeTrailed( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string' );
  let normalizedPath = this.normalize( filePath )
  let trailedPath = this.trail( normalizedPath );
  return normalizedPath === filePath || trailedPath === filePath;
}

//

/**
 * Checks if string path is normalized.
 * @param {String} filePath Source path for check
 * @returns {boolean}
 * @function isNormalized
 * @memberof module:Tools/base/Path.wTools.path
 */

function isNormalized( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string' );
  let normalizedPath = this.normalize( filePath )
  return normalizedPath === filePath;
}

//

function isAbsolute( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.strType( filePath ) );
  // _.assert( filePath.indexOf( '\\' ) === -1,'Expects refined {-filePath-}, but got', filePath );
  // _.assert(  filePath === '' || this.isRefinedMaybeTrailed( filePath ), () => 'Expects refined {-filePath-}, but got ' + _.strQuote( filePath ) );
  // _.assert( _.filePath.isNormalized( filePath ),'Expects normalized {-filePath-}, but got', filePath ); // Throws many errors
  filePath = this.refine( filePath );
  return _.strBegins( filePath, this._upStr );
}

//

function isRelative( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.strType( filePath ) );
  return !this.isAbsolute( filePath );
}

//

function isGlobal( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string' );
  return _.strHas( filePath, '://' );
  // return _.strHas( filePath, '://' ) || _.strHas( filePath, '#' );
}

//

function isRoot( filePath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( filePath ), 'Expects string {-filePath-}, but got', _.strType( filePath ) );
  if( filePath === this._rootStr )
  return true;
  if( this.isRelative( filePath ) )
  return false;
  if( this.normalize( filePath ) === this._rootStr )
  return true;

  return false;
}

//

function isDotted( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.strBegins( srcPath,this._hereStr );
}

//

function isTrailed( srcPath )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( srcPath === this._rootStr )
  return false;
  return _.strEnds( srcPath,this._upStr );
}

//

function isGlob( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );

  if( this.fileProvider && !this.fileProvider.globing )
  {
    // debugger;
    return false;
  }

  /* let regexp = /(\*\*)|([!?*])|(\[.*\])|(\(.*\))|\{.*\}+(?![^[]*\])/g; */

  return _pathIsGlobRegexp.test( src );
}

let _pathIsGlobRegexpStr = '';
_pathIsGlobRegexpStr += '(?:[?*]+)'; /* asterix,question mark */
_pathIsGlobRegexpStr += '|(?:([!?*@+]*)\\((.*?(?:\\|(.*?))*)\\))'; /* parentheses */
_pathIsGlobRegexpStr += '|(?:\\[(.+?)\\])'; /* square brackets */
_pathIsGlobRegexpStr += '|(?:\\{(.*)\\})'; /* curly brackets */
_pathIsGlobRegexpStr += '|(?:\0)'; /* zero */

let _pathIsGlobRegexp = new RegExp( _pathIsGlobRegexpStr );

//

function begins( srcPath,beginPath )
{
  _.assert( arguments.length === 2, 'Expects two arguments' );
  _.assert( _.strIs( srcPath ), 'Expects string {-srcPath-}, but got', _.strType( srcPath ) );
  _.assert( _.strIs( beginPath ), 'Expects string {-beginPath-}, but got', _.strType( beginPath ) );
  if( srcPath === beginPath )
  return true;
  return _.strBegins( srcPath,this.trail( beginPath ) );
}

//

function ends( srcPath,endPath )
{
  _.assert( arguments.length === 2, 'Expects two arguments' );
  endPath = this.undot( endPath );

  if( !_.strEnds( srcPath,endPath ) )
  return false;

  let begin = _.strRemoveEnd( srcPath,endPath );
  if( begin === '' || _.strEnds( begin,this._upStr ) || _.strEnds( begin,this._hereStr ) )
  return true;

  return false;
}

// --
// reformer
// --

/**
  * Regularize a path by replacing left slashe by slashes ( \\ to / ), and removing the end slash if trailed.
  * If the path is an empty string, method returns '.' representing the current working directory.
  *
  * @example
  *  returns '/C/temp//foo/bar/..';
  *  let path = 'C:\\temp\\\\foo\\bar\\..\\'
  *  path = wTools.refine( path );
  *
  * @param {string} src path for refinement
  * @returns {string}
  * @function refine
  * @memberof module:Tools/base/Path.wTools.path
  */

function refine( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );

  // if( !src.length ) // yyy
  // return this._hereStr;

  let result = src;

  if( result[ 1 ] === ':' )
  {
    if( result[ 2 ] === '\\' || result[ 2 ] === '/' )
    {
      if( result.length > 3 )
      result = '/' + result[ 0 ] + '/' + result.substring( 3 );
      else
      result = '/' + result[ 0 ]
    }
    else if( result.length === 2 )
    {
      result = '/' + result[ 0 ];
    }
  }

  result = result.replace( /\\/g, '/' );

  // if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) ) // yyy
  // result = _.strRemoveEnd( result, this._upStr );

  // if( result !== this._upStr )
  // result = result.replace( this._delUpRegexp, '' );

  return result;
}

//

function _normalize( o )
{
  let debug = 0;
  if( 0 )
  debug = 1;

  _.assertRoutineOptions( _normalize, arguments );
  _.assert( _.strIs( o.src ), 'Expects string' );

  if( !o.src.length )
  return '';

  let result = o.src;

  result = this.refine( result );

  // let endsWithUp = o.src === this._upStr || _.strEnds( o.src, this._upStr );
  // let beginsWithHere = o.src === this._hereStr || _.strBegins( o.src, this._hereUpStr ) || _.strBegins( o.src,this._hereStr + '\\' );

  if( debug )
  console.log( 'normalize.refined : ' + result );

  /* detrailing */

  if( o.tolerant )
  {
    /* remove "/" duplicates */
    result = result.replace( this._delUpDupRegexp, this._upStr );
  }
  else
  {
    // /* remove right "/" */
    // if( o.detrailing )
    // if( result !== this._upStr && !_.strEnds( result,this._upStr + this._upStr ) )
    // result = _.strRemoveEnd( result, this._upStr );
  }

  let endsWithUp = false;
  let beginsWithHere = false;

  /* remove right "/" */

  // if( o.detrailing )
  if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) && _.strEnds( result, this._upStr ) )
  {
    endsWithUp = true;
    result = _.strRemoveEnd( result, this._upStr );
  }

  /* undoting */

  while( !_.strBegins( result, this._hereUpStr + this._upStr ) && _.strBegins( result, this._hereUpStr ) )
  {
    beginsWithHere = true;
    result = _.strRemoveBegin( result, this._hereUpStr );
  }

  if( debug )
  console.log( 'normalize.naked : ' + result );

  /* remove second "." */

  if( result.indexOf( this._hereStr ) !== -1 )
  {

    while( this._delHereRegexp.test( result ) )
    result = result.replace( this._delHereRegexp, function( match, postSlash )
    {
      return postSlash || '';
    });
    if( result === '' )
    result = this._upStr;

  }

  if( debug )
  console.log( 'normalize.re.dot : ' + result );

  // if( result.indexOf( this._hereStr ) !== -1 )
  // {
  //   while( this._delHereRegexp.test( result ) )
  //   result = result.replace( this._delHereRegexp, ( match, a, b, c, d ) =>
  //   {
  //
  //     if( a )
  //     return a;
  //     if( b && c === undefined )
  //     return b;
  //     return d || '';
  //
  //   });
  // }

  // if( _.strBegins( result, this._hereUpStr ) && !_.strBegins( result,this._hereUpStr + this._upStr ) )
  // result = _.strRemoveBegin( result, this._hereUpStr );

  // /* remove right "/" */
  //
  // if( o.detrailing )
  // if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) )
  // result = _.strRemoveEnd( result, this._upStr );
  //
  // /* undoting */
  //
  // // if( o.undoting )
  // // if( _.strBegins( result, this._hereUpStr ) && !_.strBegins( result, this._hereUpStr + this._upStr ) )
  // if( !_.strBegins( result, this._hereUpStr + this._upStr ) )
  // result = _.strRemoveBegin( result, this._hereUpStr );

  /* remove .. */

  if( result.indexOf( this._downStr ) !== -1 )
  {

    // debugger;
    // if( this._delDownRegexp.test( result ) )
    while( this._delDownRegexp.test( result ) )
    result = result.replace( this._delDownRegexp, ( match, notBegin, split, preSlash, postSlash ) =>
    {
      // debugger;
      if( preSlash === '' )
      return notBegin;
      if( !notBegin )
      return notBegin + preSlash;
      else
      return notBegin + ( postSlash || '' );
    });
    // debugger;

    // while( this._delDownFirstRegexp.test( result ) )
    // result = result.replace( this._delDownFirstRegexp,'' );

    // if( !_.strBegins( result, this._hereUpStr + this._upStr ) )
    // result = _.strRemoveBegin( result, this._hereUpStr );

  }

  // /* remove second ".." */
  //
  // if( result.indexOf( this._downStr ) !== -1 )
  // {
  //   // debugger;
  //   while( this._delDownSecondRegexp.test( result ) )
  //   result = result.replace( this._delDownSecondRegexp, function( match, preSlash1, preSlash2, postSlash )
  //   {
  //     // debugger;
  //     _.assert( arguments.length === 6 );
  //     let pre = '';
  //     if( preSlash1 && preSlash2 )
  //     {
  //       pre = preSlash1 + preSlash2;
  //       postSlash = '';
  //     }
  //     return pre + ( postSlash || '' );
  //   });
  //   // debugger;
  // }
  //
  // if( debug )
  // console.log( 'normalize.re.ddot1 : ' + result );
  //
  // /* remove first ".." */
  //
  // if( result.indexOf( this._downStr ) !== -1 )
  // {
  //
  //   if( this._delDownFirstRegexp.test( result ) )
  //   result = result.replace( this._delDownFirstRegexp, ( match, a, b, c ) =>
  //   {
  //     let r = '';
  //     if( a )
  //     r = a;
  //     else if( c )
  //     r = '.' + c;
  //     return r;
  //   });
  //
  //   // while( this._delDownFirstRegexp.test( result ) )
  //   // result = result.replace( this._delDownFirstRegexp,'' );
  //
  //   if( !_.strBegins( result, this._hereUpStr + this._upStr ) )
  //   result = _.strRemoveBegin( result, this._hereUpStr );
  //
  // }

  if( debug )
  console.log( 'normalize.re.ddot : ' + result );

  /* remove "." */

  // if( result !== this._hereUpStr )
  // if( _.strBegins( result, this._hereUpStr ) && !_.strBegins( result,this._hereUpStr + this._upStr ) )
  // result = _.strRemoveBegin( result, this._hereUpStr );

  // /* detrailing */
  //
  // if( o.tolerant )
  // {
  //   /* remove "/" duplicates */
  //   result = result.replace( this._delUpDupRegexp, this._upStr );
  // }
  // else
  // {
  //   /* remove right "/" */
  //   if( o.detrailing )
  //   if( result !== this._upStr && !_.strEnds( result,this._upStr + this._upStr ) )
  //   result = _.strRemoveEnd( result, this._upStr );
  // }

  /* nothing left */

  if( !result.length )
  result = '.';

  /* dot and trail */

  if( o.detrailing )
  if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) )
  result = _.strRemoveEnd( result, this._upStr );

  if( !o.detrailing && endsWithUp )
  if( result !== this._rootStr )
  result = result + this._upStr;

  if( !o.undoting && beginsWithHere )
  result = this.dot( result );

  if( debug )
  console.log( 'normalize.result : ' + result );

  return result;
}

_normalize.defaults =
{
  src : null,
  tolerant : false,
  detrailing : false,
  undoting : false,
}

//

/**
 * Regularize a path by collapsing redundant delimeters and resolving '..' and '.' segments,so A//B,A/./B and
    A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links.
    On Windows,it converts forward slashes to backward slashes. If the path is an empty string,method returns '.'
    representing the current working directory.
 * @example
   let path = '/foo/bar//baz1/baz2//some/..'
   path = wTools.normalize( path ); // /foo/bar/baz1/baz2
 * @param {string} src path for normalization
 * @returns {string}
 * @function normalize
 * @memberof module:Tools/base/Path.wTools.path
 */

function normalize( src )
{
  let result = this._normalize({ src, tolerant : false, detrailing : false, undoting : false });

  _.assert( _.strIs( src ), 'Expects string' );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this._upStr + this._downStr + this._upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
  }

  return result;
}

//

function normalizeTolerant( src )
{
  _.assert( _.strIs( src ),'Expects string' );

  let result = this._normalize({ src, tolerant : true, detrailing : false, undoting : false });

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result === this._upStr || _.strEnds( result, this._upStr ) || !_.strEnds( result, this._upStr + this._upStr ) );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    _.assert( !this._delUpDupRegexp.test( result ) );
  }

  return result;
}

//

function normalizeCanonical( src )
{
  let result = this._normalize({ src, tolerant : false, detrailing : true, undoting : true });

  _.assert( _.strIs( src ), 'Expects string' );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result === this._upStr || _.strEnds( result, this._upStr + this._upStr ) || !_.strEnds( result, this._upStr ) );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this._upStr + this._downStr + this._upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
  }

  return result;
}

//

function normalizeCanonicalTolerant( src )
{
  _.assert( _.strIs( src ),'Expects string' );

  let result = this._normalize({ src, tolerant : true, detrailing : true, undoting : true });

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( result === this._upStr || _.strEnds( result, this._upStr ) || !_.strEnds( result, this._upStr + this._upStr ) );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    _.assert( !this._delUpDupRegexp.test( result ) );
  }

  return result;
}

//

function _pathNativizeWindows( filePath )
{
  let self = this;
  _.assert( _.strIs( filePath ), 'Expects string' ) ;
  let result = filePath.replace( /\//g, '\\' );

  if( result[ 0 ] === '\\' )
  if( result.length === 2 || result[ 2 ] === ':' || result[ 2 ] === '\\' )
  result = result[ 1 ] + ':' + result.substring( 2 );

  return result;
}

//

function _pathNativizeUnix( filePath )
{
  let self = this;
  _.assert( _.strIs( filePath ), 'Expects string' );
  return filePath;
}

//

let nativize;
if( _global.process && _global.process.platform === 'win32' )
nativize = _pathNativizeWindows;
else
nativize = _pathNativizeUnix;

// --
// transformer
// --

function from( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( src ) )
  return src;
  else
  _.assert( 0, 'Expects string, but got ' + _.strType( src ) );

}

//

function dot( filePath )
{

  /*
    cant use isAbsolute
  */

  // _.assert( !this.isAbsolute( path ) );
  _.assert( !_.strBegins( filePath, this._upStr ) );
  _.assert( arguments.length === 1 );

  /*
    not .
    not begins with ./
    not ..
    not begins with ../
  */

  if( filePath !== this._hereStr && !_.strBegins( filePath, this._hereUpStr ) && filePath !== this._downStr && !_.strBegins( filePath, this._downUpStr ) )
  {
    _.assert( !_.strBegins( filePath, this._upStr ) );
    filePath = this._hereUpStr + filePath;
  }

  return filePath;
}

//

function undot( filePath )
{
  return _.strRemoveBegin( filePath, this._hereUpStr );
}

//

function trail( srcPath )
{
  _.assert( this.is( srcPath ) );
  _.assert( arguments.length === 1 );

  if( !_.strEnds( srcPath,this._upStr ) )
  return srcPath + this._upStr;

  return srcPath;
}

//

function detrail( path )
{
  _.assert( this.is( path ) );
  _.assert( arguments.length === 1 );

  if( path !== this._rootStr )
  return _.strRemoveEnd( path,this._upStr );

  return path;
}

//

/**
 * Returns the directory name of `path`.
 * @example
 * let path = '/foo/bar/baz/text.txt'
 * wTools.dir( path ); // '/foo/bar/baz'
 * @param {string} path path string
 * @returns {string}
 * @throws {Error} If argument is not string
 * @function dir
 * @memberof module:Tools/base/Path.wTools.path
 */

function dir_pre( routine, args )
{
  let o = args[ 0 ];
  if( _.strIs( o ) )
  o = { filePath : o };

  _.routineOptions( routine, o );
  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.strDefined( o.filePath ), 'Expects not empty string {- o.filePath -}' );

  return o;
}

function dir_body( o )
{

  _.assertRoutineOptions( dir_body, arguments );

  let isTrailed = this.isTrailed( o.filePath );

  if( o.first )
  o.filePath = this.normalize( o.filePath );
  else
  o.filePath = this.normalizeCanonical( o.filePath );

  if( o.first )
  if( isTrailed )
  return o.filePath;

  if( o.filePath === this._rootStr )
  {
    return o.filePath + this._downStr + this._upStr;
  }

  if( _.strEnds( o.filePath, this._upStr + this._downStr ) || o.filePath === this._downStr )
  {
    return o.filePath + this._upStr + this._downStr + this._upStr;
  }

  let i = o.filePath.lastIndexOf( this._upStr );

  if( i === -1 )
  {
    if( o.filePath === this._hereStr )
    return this._downStr + this._upStr;
    else
    return this._hereStr + this._upStr;
  }

  // if( o.first )
  // if( o.filePath[ i - 1 ] === '/' )
  // return o.filePath;

  let result = o.filePath.substr( 0, i+1 );

  // if( result === '' )
  // result = this._rootStr;

  _.assert( !!result.length )

  return result;
}

dir_body.defaults =
{
  filePath : null,
  first : 0,
}

let dir = _.routineFromPreAndBody( dir_pre, dir_body );
dir.defaults.first = 0;

let dirFirst = _.routineFromPreAndBody( dir_pre, dir_body );
dirFirst.defaults.first = 1;

//

/**
 * Returns dirname + filename without extension
 * @example
 * _.path.prefixGet( '/foo/bar/baz.ext' ); // '/foo/bar/baz'
 * @param {string} path Path string
 * @returns {string}
 * @throws {Error} If passed argument is not string.
 * @function prefixGet
 * @memberof module:Tools/base/Path.wTools.path
 */

function prefixGet( path )
{

  if( !_.strIs( path ) )
  throw _.err( 'prefixGet :','Expects strings as path' );

  let n = path.lastIndexOf( '/' );
  if( n === -1 ) n = 0;

  let parts = [ path.substr( 0, n ),path.substr( n ) ];

  n = parts[ 1 ].indexOf( '.' );
  if( n === -1 )
  n = parts[ 1 ].length;

  let result = parts[ 0 ] + parts[ 1 ].substr( 0,n );

  return result;
}

//

/**
 * Returns path name (file name).
 * @example
 * wTools.name( '/foo/bar/baz.asdf' ); // 'baz'
 * @param {string|object} path|o Path string,or options
 * @param {boolean} o.full if this parameter set to true method return name with extension.
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @function name
 * @memberof module:Tools/base/Path.wTools.path
 */

function name_pre( routine, args )
{
  let o = args[ 0 ];
  if( _.strIs( o ) )
  o = { path : o };

  _.routineOptions( routine, o );
  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );

  return o;
}

function name_body( o )
{

  if( _.strIs( o ) )
  o = { path : o };

  o = _.assertRoutineOptions( name, arguments );
  _.assert( o && _.strIs( o.path ), 'Expects strings {-o.path-}' );

  o.path = this.normalizeCanonical( o.path );

  let i = o.path.lastIndexOf( '/' );
  if( i !== -1 )
  o.path = o.path.substr( i+1 );

  if( !o.full )
  {
    let i = o.path.lastIndexOf( '.' );
    if( i !== -1 ) o.path = o.path.substr( 0, i );
  }

  return o.path;
}

name_body.defaults =
{
  path : null,
  full : 0,
}

let name = _.routineFromPreAndBody( name_pre, name_body );
name.defaults.full = 0;

let fullName = _.routineFromPreAndBody( name_pre, name_body );
fullName.defaults.full = 1;

//

/**
 * Return path without extension.
 * @example
 * wTools.withoutExt( '/foo/bar/baz.txt' ); // '/foo/bar/baz'
 * @param {string} path String path
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @function withoutExt
 * @memberof module:Tools/base/Path.wTools.path
 */

function withoutExt( path )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string' );

  let name = _.strIsolateRightOrNone( path,'/' )[ 2 ] || path;

  let i = name.lastIndexOf( '.' );
  if( i === -1 || i === 0 )
  return path;

  let halfs = _.strIsolateRightOrNone( path,'.' );
  return halfs[ 0 ];
}

//

/**
 * Replaces existing path extension on passed in `ext` parameter. If path has no extension,adds passed extension
    to path.
 * @example
 * wTools.changeExt( '/foo/bar/baz.txt', 'text' ); // '/foo/bar/baz.text'
 * @param {string} path Path string
 * @param {string} ext
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @function changeExt
 * @memberof module:Tools/base/Path.wTools.path
 */

// qqq : extend tests

function changeExt( path, ext )
{

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( ext ) );
  }
  else if( arguments.length === 3 )
  {
    let sub = arguments[ 1 ];
    let ext = arguments[ 2 ];

    _.assert( _.strIs( sub ) );
    _.assert( _.strIs( ext ) );

    let cext = this.ext( path );

    if( cext !== sub )
    return path;
  }
  else _.assert( 'Expects 2 or 3 arguments' );

  if( ext === '' )
  return this.withoutExt( path );
  else
  return this.withoutExt( path ) + '.' + ext;

}

//

function _pathsChangeExt( src )
{
  _.assert( _.longIs( src ) );
  _.assert( src.length === 2 );

  return changeExt.apply( this,src );
}

//

/**
 * Returns file extension of passed `path` string.
 * If there is no '.' in the last portion of the path returns an empty string.
 * @example
 * _.path.ext( '/foo/bar/baz.ext' ); // 'ext'
 * @param {string} path path string
 * @returns {string} file extension
 * @throws {Error} If passed argument is not string.
 * @function ext
 * @memberof module:Tools/base/Path.wTools.path
 */

function ext( path )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string {-path-}, but got', _.strType( path ) );

  let index = path.lastIndexOf( '/' );
  if( index >= 0 )
  path = path.substr( index+1, path.length-index-1  );

  index = path.lastIndexOf( '.' );
  if( index === -1 || index === 0 )
  return '';

  index += 1;

  return path.substr( index, path.length-index ).toLowerCase();
}

//

/*
qqq : not covered by tests
*/

function exts( path )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string {-path-}, but got', _.strType( path ) );

  path = this.name({ path,full : 1 });

  let exts = path.split( '.' );
  exts.splice( 0, 1 );
  exts = _.entityFilter( exts , ( e ) => !e ? undefined : e.toLowerCase() );

  return exts;
}

// --
// joiner
// --

/**
 * Joins filesystem paths fragments or urls fragment into one path/url. Uses '/' level delimeter.
 * @param {Object} o join o.
 * @param {String[]} p.paths - Array with paths to join.
 * @param {boolean} [o.reroot=false] If this parameter set to false (by default), method joins all elements in
 * `paths` array,starting from element that begins from '/' character,or '* :', where '*' is any drive name. If it
 * is set to true,method will join all elements in array. Result
 * @returns {string}
 * @private
 * @throws {Error} If missed arguments.
 * @throws {Error} If elements of `paths` are not strings
 * @throws {Error} If o has extra parameters.
 * @function join_body
 * @memberof module:Tools/base/Path.wTools.path
 */

function join_body( o )
{
  let self = this;
  let result = null;
  let prepending = true;

  /* */

  _.assert( Object.keys( o ).length === 4 );
  _.assert( o.paths.length > 0 );
  _.assert( _.boolLike( o.reroot ) );

  /* */

  if( Config.debug )
  for( let a = o.paths.length-1 ; a >= 0 ; a-- )
  {
    let src = o.paths[ a ];
    _.assert( _.strIs( src ) || src === null, () => 'Expects strings as path arguments, but #' + a + ' argument is ' + _.strType( src ) );
  }

  /* */

  for( let a = o.paths.length-1 ; a >= 0 ; a-- )
  {
    let src = o.paths[ a ];

    if( o.allowingNull )
    if( src === null )
    break;

    if( result === null )
    result = '';

    // _.assert( _.strIs( src ), () => 'Expects strings as path arguments, but #' + a + ' argument is ' + _.strType( src ) );

    prepending = prepend( src );
    if( prepending === false )
    break;

  }

  /* */

  // if( result === '' )
  // return '.';

  // if( !o.raw && result !== null )
  // result = this.normalize( result );

  if( !o.raw && result !== null )
  result = self.normalize( result );

  return result;

  /* */

  function prepend( src )
  {

    if( src )
    src = self.refine( src );

    if( !src )
    return prepending;

    // xxx
    // if( result === self._hereStr )
    // {
    //   result = src;
    //   return prepending;
    // }

    if( prepending )
    {

      src = src.replace( /\\/g, '/' );

      if( result && src[ src.length-1 ] === '/' && !_.strEnds( src, '//' ) )
      if( src.length > 1 || result[ 0 ] === '/' )
      src = src.substr( 0, src.length-1 );

      if( src && src[ src.length-1 ] !== '/' && result && result[ 0 ] !== '/' )
      result = '/' + result;

      result = src + result;

    }

    if( !o.reroot )
    {
      if( src[ 0 ] === '/' )
      return false;
    }

    return prepending;
  }

}

join_body.defaults =
{
  paths : null,
  reroot : 0,
  allowingNull : 1,
  raw : 0,
}

//

/**
 * Method joins all `paths` together,beginning from string that starts with '/', and normalize the resulting path.
 * @example
 * let res = wTools.join( '/foo', 'bar', 'baz', '.');
 * // '/foo/bar/baz'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory delimeter.
 * @throws {Error} If one of passed arguments is not string
 * @function join
 * @memberof module:Tools/base/Path.wTools.path
 */

function join()
{

  let result = this.join_body
  ({
    paths : arguments,
    reroot : 0,
    allowingNull : 1,
    raw : 0,
  });

  return result;
}

//

function joinRaw()
{

  let result = this.join_body
  ({
    paths : arguments,
    reroot : 0,
    allowingNull : 1,
    raw : 1,
  });

  return result;
}

//

function joinIfDefined()
{
  let args = _.filter( arguments, ( arg ) => arg );
  if( !args.length )
  return;
  return this.join.apply( this,args );
}

//

function joinCross()
{

  if( _.arrayHasArray( arguments ) )
  {
    let result = [];

    let samples = _.eachSample( arguments );
    for( var s = 0 ; s < samples.length ; s++ )
    result.push( this.join.apply( this,samples[ s ] ) );
    return result;

  }

  return this.join.apply( this,arguments );
}

//

/**
 * Method joins all `paths` strings together.
 * @example
 * let res = wTools.reroot( '/foo', '/bar/', 'baz', '.');
 * // '/foo/bar/baz/.'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory delimeter.
 * @throws {Error} If one of passed arguments is not string
 * @function reroot
 * @memberof module:Tools/base/Path.wTools.path
 */

function reroot()
{
  let result = this.join_body
  ({
    paths : arguments,
    reroot : 1,
    allowingNull : 1,
    raw : 0,
  });
  return result;
}

//

/**
 * Method resolves a sequence of paths or path segments into an absolute path.
 * The given sequence of paths is processed from right to left,with each subsequent path prepended until an absolute
 * path is constructed. If after processing all given path segments an absolute path has not yet been generated,
 * the current working directory is used.
 * @example
 * let absPath = wTools.resolve('work/wFiles'); // '/home/user/work/wFiles';
 * @param [...string] paths A sequence of paths or path segments
 * @returns {string}
 * @function resolve
 * @memberof module:Tools/base/Path.wTools.path
 */

function resolve()
{
  let path;

  _.assert( arguments.length > 0 );

  path = this.join.apply( this,arguments );

  if( path === null )
  return path;
  else if( !this.isAbsolute( path ) )
  path = this.join( this.current(), path );

  path = this.normalize( path );

  _.assert( path.length > 0 );

  return path;
}

//

function joinNames()
{

  // Variables

  let prefixs = [];         // Prefixes array
  let names = [];           // Names array
  let exts = [];            // Extensions array
  let extsBool = false;     // Check if there are extensions
  let prefixBool = false;   // Check if there are prefixes
  let start = -1;           // Index of the starting prefix
  let numStarts = 0;        // Number of starting prefixes
  let numNull = 0;          // Number of null prefixes
  let longerI = -1;         // Index of the longest prefix
  let maxPrefNum = 0;       // Length of the longest prefix

  // Check input elements are strings
  if( Config.debug )
  for( let a = arguments.length-1 ; a >= 0 ; a-- )
  {
    let src = arguments[ a ];
    _.assert( _.strIs( src ) || src === null );
  }

  for( let a = arguments.length-1 ; a >= 0 ; a-- ) // Loop over the arguments ( starting by the end )
  {
    let src = arguments[ a ];

    if( src === null )  // Null arg,break loop
    {
      prefixs.splice( 0,a + 1 );
      numNull = numNull + a + 1;
      break;
    }

    src = this.normalize(  src );

    let prefix = this.prefixGet( src );

    if( prefix.charAt( 0 ) === '/' )   // Starting prefix
    {
      prefixs[ a ] = src + '/';
      names[ a ] = '';
      exts[ a ] = '';
      start = a;
      numStarts = numStarts + 1;
    }
    else
    {
      names[ a ] = this.name( src );
      prefixs[ a ] = prefix.substring( 0,prefix.length - ( names[ a ].length + 1 ) );
      prefix = prefix.substring( 0,prefix.length - ( names[ a ].length ) );
      exts[ a ] = this.ext( src );

      if( prefix.substring( 0,2 ) === './')
      {
        prefixs[ a ] = prefixs[ a ].substring( 2 );
      }

      prefixs[ a ] = prefixs[ a ].split("/");

      let prefNum = prefixs[ a ].length;

      if( maxPrefNum < prefNum )
      {
        maxPrefNum = prefNum;
        longerI = a;
      }

      let empty = prefixs[ a ][ 0 ] === '' && names[ a ] === '' && exts[ a ] === '';

      if( empty && src.charAt( 0 ) === '.' )
      exts[ a ] = src.substring( 1 );

    }

    if( exts[ a ] !== '' )
    extsBool = true;

    if( prefix !== '' )
    prefixBool = true;

  }

  longerI = longerI - numStarts - numNull;

  let result = names.join( '' );

  if( prefixBool === true )
  {
    if( start !== -1 )
    {
      logger.log( prefixs,start)
      var first = prefixs.splice( start,1 );
    }

    for( let p = 0; p < maxPrefNum; p++ )
    {
      for( let j = prefixs.length - 1; j >= 0; j-- )
      {
        let pLong = prefixs[ longerI ][ maxPrefNum - 1 - p ];
        let pj = prefixs[ j ][ prefixs[ j ].length - 1 - p ];
        if( j !== longerI )
        {
          if( pj !== undefined && pLong !== undefined )
          {

            if( j < longerI )
            {
              prefixs[ longerI ][ maxPrefNum - 1 - p ] =  this.joinNames.apply( this, [ pj,pLong ] );
            }
            else
            {
              prefixs[ longerI ][ maxPrefNum - 1 - p ] =  this.joinNames.apply( this, [ pLong,pj ] );
            }
          }
          else if( pLong === undefined  )
          {
            prefixs[ longerI ][ maxPref - 1 - p ] =  pj;
          }
          else if( pj === undefined  )
          {
            prefixs[ longerI ][ maxPrefNum - 1 - p ] =  pLong;
          }
        }
      }
    }

    let pre = this.join.apply( this,prefixs[ longerI ] );
    result = this.join.apply( this, [ pre,result ] );

    if( start !== -1 )
    {
      result =  this.join.apply( this, [ first[ 0 ], result ] )
    }

  }

  if( extsBool === true )
  {
    result = result + '.' + exts.join( '' );
  }

  // qqq : what is normalize for?
  result = this.normalize( result );

  return result;
}

/*
function joinNames()
{
  let names = [];
  let exts = [];

  if( Config.debug )
  for( let a = arguments.length-1 ; a >= 0 ; a-- )
  {
    let src = arguments[ a ];
    _.assert( _.strIs( src ) || src === null );
  }

  for( let a = arguments.length-1 ; a >= 0 ; a-- )
  {
    let src = arguments[ a ];
    if( src === null )
    break;
    names[ a ] = this.name( src );
    exts[ a ] = src.substring( names[ a ].length );
  }

  let result = names.join( '' ) + exts.join( '' );

  return result;
}
*/

//

function _split( path )
{
  return path.split( this._upStr );
}

//

function split( path )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string' )
  let result = this._split( this.refine( path ) );
  return result;
}

// --
// stater
// --

function current()
{
  _.assert( arguments.length === 0 );
  return this._upStr;
}

// --
// relator
// --

/**
* Returns a relative path to `path` from an `relative` path. This is a path computation : the filesystem is not
* accessed to confirm the existence or nature of path or start.

* * If `o.relative` and `o.path` each resolve to the same path method returns `.`.
* * If `o.resolving` is enabled -- paths `o.relative` and `o.path` are resolved before computation, uses result of {@link module:Tools/base/Path.Path.current _.path.current} as base.
* * If `o.resolving` is disabled -- paths `o.relative` and `o.path` are not resolved and must be both relative or absolute.
*
* **Examples of how result is computed and how to chech the result:**
*
* Result is checked by a formula : from + result === to, where '+' means join operation {@link module:Tools/base/Path.Path.join _.path.join}
*
* **Note** :
* * `from` -- `o.relative`
* * `to` -- `o.path`
* * `cd` -- current directory
*
* *Example #1*
*   ```
*   from : /a
*   to : /b
*   result : ../b
*   from + result = to : /a + ../b = /b
*   ```
* *Example #2*
*   ```
*   from : /
*   to : /b
*   result : ./b
*   from + result = to : / + ./b = /b
*   ```
* *Example #3*
*   ```
*   resolving : 0
*   from : ..
*   to : .
*   result : .
*   from + result = to : .. + . != .. <> . -- error because result doesn't satisfy the final check
*   from + result = to : .. + .. != ../.. <> . -- error because result doesn't satisfy the final check
*   ```
*
* *Example #4*
*   ```
*   resolving : 1
*   cd : /d -- current dir
*   from : .. -> /
*   to : . -> /d
*   result : ./d
*   from + result = to : / + ./d === /d
*   ```
*
* *Example #5*
*   ```
*   resolving : 0
*   from : ../a/b
*   to : ../c/d
*   result : ../../c/d
*   from + result = to : ../a/b + ../../c/d === ../c/d
*   ```
*
* *Example #6*
*   ```
*   resolving : 1
*   cd : /
*   from : ../a/b -> /../a/b
*   to : ../c/d -> /../c/d
*   from + result = to : /../a/b + /../../c/d === /../c/d -- error resolved "from" leads out of file system
*   ```
*
* *Example #7*
*   ```
*   resolving : 0
*   from : ..
*   to : ./a
*   result : ../a
*   from + result = to : .. + ../a != ./a -- error because result doesn't satisfy the final check
*   ```
* *Example #8*
*   ```
*   resolving : 1
*   cd : /
*   from : .. -> /..
*   to : ./a -> /a
*   result : /../a
*   from + result = to : .. + ../a != ./a -- error resolved "from" leads out of file system
*   ```
*
* @param {Object} [o] Options map.
* @param {String|wFileRecord} [o.relative] Start path.
* @param {String|String[]} [o.path] Targer path(s).
* @param {String|String[]} [o.resolving=0] Resolves {o.relative} and {o.path} before computation.
* @param {String|String[]} [o.dotted=1] Allows '.' as the result, otherwise returns empty string.
* @returns {String|String[]} Returns relative path as String or array of Strings.
* @throws {Exception} If {o.resolving} is enabled and {o.relative} or {o.path} leads out of file system.
* @throws {Exception} If result of computation doesn't satisfy formula: o.relative + result === o.path.
* @throws {Exception} If {o.relative} is not a string or wFileRecord instance.
* @throws {Exception} If {o.path} is not a string or array of strings.
* @throws {Exception} If both {o.relative} and {path} are not relative or absolute.
*
* @example
* let from = '/a';
* let to = '/b'
* _.path._relative({ relative : from, path : to, resolving : 0 });
* //'../b'
*
* @example
* let from = '../a/b';
* let to = '../c/d'
* _.path._relative({ relative : from, path : to, resolving : 0 });
* //'../../c/d'
*
* @example
* //resolving, assume that cd is : '/d'
* let from = '..';
* let to = '.'
* _.path._relative({ relative : from, path : to, resolving : 1 });
* //'./d'
*
* @function _relative
* @memberof module:Tools/base/Path.wTools.path
*/

function _relative( o )
{
  let self = this;
  let result = '';
  let basePath = this.from( o.basePath );
  let filePath = this.from( o.filePath );

  _.assert( _.strIs( basePath ),'Expects string {-basePath-}, but got', _.strType( basePath ) );
  _.assert( _.strIs( filePath ) || _.arrayIs( filePath ) );
  _.assertRoutineOptions( _relative, arguments );
  o.basePath = this.from( o.basePath );
  o.filePath = this.from( o.filePath );

  if( !o.resolving )
  {
    basePath = this.normalize( basePath );
    filePath = this.normalize( filePath );

    let relativeIsAbsolute = this.isAbsolute( basePath );
    let isAbsoulute = this.isAbsolute( filePath );

    /* makes common style for relative paths, each should begin from './' */

    if( !relativeIsAbsolute && basePath !== this._hereStr )
    basePath = _.strPrependOnce( basePath, this._hereUpStr );
    if( !isAbsoulute && filePath !== this._hereStr )
    filePath = _.strPrependOnce( filePath, this._hereUpStr );

    _.assert( relativeIsAbsolute && isAbsoulute || !relativeIsAbsolute && !isAbsoulute, 'Both paths must be either absolute or relative.' );
  }
  else
  {
    basePath = this.resolve( basePath );
    filePath = this.resolve( filePath );

    _.assert( this.isAbsolute( basePath ) );
    _.assert( this.isAbsolute( filePath ) );

    _.assert( !_.strBegins( basePath, this._upStr + this._downStr ), 'Resolved o.basePath:', basePath, 'leads out of file system.' );
    _.assert( !_.strBegins( filePath, this._upStr + this._downStr ), 'Resolved o.filePath:', filePath, 'leads out of file system.' );
  }

  _.assert( basePath.length > 0 );
  _.assert( filePath.length > 0 );

  /* extracts common filePath and checks if its a intermediate dir, otherwise cuts filePath and repeats the check*/

  let common = _.strCommonLeft( basePath, filePath );
  let commonTrailed = _.strAppendOnce( common, this._upStr );
  if( !_.strBegins( _.strAppendOnce( basePath, this._upStr ), commonTrailed ) || !_.strBegins( _.strAppendOnce( filePath, this._upStr ), commonTrailed ) )
  {
    common = this.dir( common );
  }

  //

  /* gets count of up steps required to get to common dir */
  basePath = _.strRemoveBegin( basePath, common );
  filePath = _.strRemoveBegin( filePath, common );

  let basePath2 = _.strRemoveBegin( _.strRemoveEnd( basePath, this._upStr ), this._upStr );
  let count = _.strCount( basePath2, this._upStr );

  if( basePath === this._upStr || !basePath )
  count = 0;
  else
  count += 1;

  if( !_.strBegins( filePath, this._upStr + this._upStr ) && common !== this._upStr )
  filePath = _.strRemoveBegin( filePath, this._upStr );

  /* prepends up steps */
  if( filePath || count === 0 )
  result = _.strDup( this._downUpStr, count ) + filePath;
  else
  result = _.strDup( this._downUpStr, count-1 ) + this._downStr;

  /* removes redundant slash at the end */
  if( _.strEnds( result, this._upStr ) )
  _.assert( result.length > this._upStr.length );

  if( result === '' )
  result = this._hereStr;

  if( _.strEnds( o.filePath, this._upStr ) && !_.strEnds( result, this._upStr ) )
  if( o.basePath !== this._rootStr )
  result = result + this._upStr;

  /* checks if result is normalized */

  _.assert( result.length > 0 );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result, this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this._upStr + this._downStr + this._upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0, i ) ) );
    if( o.resolving )
    _.assert( this.resolve( o.basePath, result ) === this.resolve( o.filePath ), () => o.basePath + ' + ' + result + ' <> ' + this.resolve( o.filePath ) );
    else
    _.assert( this.normalizeCanonical( this.join( o.basePath, result ) ) === this.normalizeCanonical( o.filePath ), () => o.basePath + ' + ' + result + ' <> ' + this.normalize( o.filePath ) );
  }

  return result;
}

_relative.defaults =
{
  basePath : null,
  filePath : null,
  resolving : 0,
}

//

/**
* Short-cut for routine relative {@link module:Tools/base/Path.Path._relative _.path._relative}.
* Returns a relative path to `path` from an `relative`. Does not resolve paths {o.relative} and {o.path} before computation.
*
* @param {string|wFileRecord} relative Start path.
* @param {string|string[]} path Target path(s).
* @returns {string|string[]} Returns relative path as String or array of Strings.
* For more details please see {@link module:Tools/base/Path.Path._relative _.path._relative}.
*
* @example
* let from = '/a';
* let to = '/b'
* _.path.relative( from, to );
* //'../b'
*
* @example
* let from = '/';
* let to = '/b'
* _.path.relative( from, to );
* //'./b'
*
* @example
* let from = '/a/b';
* let to = '/c'
* _.path.relative( from, to );
* //'../../c'
*
* @example
* let from = '/a';
* let to = './b'
* _.path.relative( from, to ); // throws an error paths have different type
*
* @example
* let from = '.';
* let to = '..'
* _.path.relative( from, to );
* //'..'
*
* @example
* let from = '..';
* let to = '..'
* _.path.relative( from, to );
* //'.'
*
* @example
* let from = '../a/b';
* let to = '../c/d'
* _.path.relative( from, to );
* //'../../c/d'
*
* @function relative
* @memberof module:Tools/base/Path.wTools.path
*/

function relative_pre( routine, args )
{
  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { basePath : args[ 0 ], filePath : args[ 1 ] }

  _.routineOptions( routine, o );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 2 );

  return o;
}

//

function relative_body( o )
{
  return this._relative( o );
}

relative_body.defaults = Object.create( _relative.defaults );

let relative = _.routineFromPreAndBody( relative_pre, relative_body );

//

function relativeCommon()
{
  let commonPath = this.common( filePath );
  let relativePath = [];

  for( let i = 0 ; i < filePath.length ; i++ )
  relativePath[ i ] = this.relative( commonPath,filePath[ i ] );

  return relativePath;
}

//

function _commonPair( src1, src2 )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( src1 ) && _.strIs( src2 ) );

  let result = [];
  let first = parsePath( src1 );
  let second = parsePath( src2 );

  let needToSwap = first.isRelative && second.isAbsolute;
  if( needToSwap )
  {
    let tmp = second;
    second = first;
    first = tmp;
  }

  let bothAbsolute = first.isAbsolute && second.isAbsolute;
  let bothRelative = first.isRelative && second.isRelative;
  let absoluteAndRelative = first.isAbsolute && second.isRelative;

  if( absoluteAndRelative )
  {
    if( first.splitted.length > 3 || first.splitted[ 0 ] !== '' || first.splitted[ 2 ] !== '' || first.splitted[ 1 ] !== '/' )
    {
      debugger;
      throw _.err( 'Incompatible paths.' );
    }
    else
    return '/';
  }

  if( bothAbsolute )
  {
    getCommon();

    result = result.join('');

    if( !result.length )
    result = '/';
  }

  if( bothRelative )
  {

    if( first.levelsDown === second.levelsDown )
    getCommon();

    result = result.join('');

    let levelsDown = Math.max( first.levelsDown,second.levelsDown );

    if( levelsDown > 0 )
    {
      let prefix = _.arrayFillTimes( [], levelsDown,self._downStr );
      prefix = prefix.join( '/' );
      result = prefix + result;
    }

    if( !result.length )
    {
      if( first.isRelativeHereThen && second.isRelativeHereThen )
      result = self._hereStr;
      else
      result = '.';
    }
  }

  return result;

  /* - */

  function getCommon()
  {
    let length = Math.min( first.splitted.length,second.splitted.length );
    for( let i = 0; i < length; i++ )
    {
      if( first.splitted[ i ] === second.splitted[ i ] )
      {
        if( first.splitted[ i ] === self._upStr && first.splitted[ i + 1 ] === self._upStr )
        break;
        else
        result.push( first.splitted[ i ] );
      }
      else
      break;
    }
  }

  function parsePath( path )
  {
    let result =
    {
      isRelativeDown : false,
      isRelativeHereThen : false,
      isRelativeHere : false,
      levelsDown : 0,
    };

    // result.normalized = self.normalizeTolerant( path );
    result.normalized = self.normalize( path );
    result.splitted = split( result.normalized );
    result.isAbsolute = self.isAbsolute( result.normalized );
    result.isRelative = !result.isAbsolute;

    if( result.isRelative )
    if( result.splitted[ 0 ] === self._downStr )
    {
      result.levelsDown = _.arrayCountElement( result.splitted,self._downStr );
      let substr = _.arrayFillTimes( [], result.levelsDown,self._downStr ).join( '/' );
      let withoutLevels = _.strRemoveBegin( result.normalized,substr );
      result.splitted = split( withoutLevels );
      result.isRelativeDown = true;
    }
    else if( result.splitted[ 0 ] === '.' )
    {
      result.splitted = result.splitted.splice( 2 );
      result.isRelativeHereThen = true;
    }
    else
    result.isRelativeHere = true;

    return result;
  }

  function split( src )
  {
    return _.strSplitFast( { src,delimeter : [ '/' ], preservingDelimeters : 1,preservingEmpty : 1 } );
  }

}

//

function group( o )
{
  let self = this;

  _.routineOptions( group, arguments );
  _.assert( _.arrayIs( o.vals ) );
  _.assert( o.result === null || _.mapIs( o.result ) );

  o.result = o.result || Object.create( null );
  o.result[ '/' ] = o.result[ '/' ] || [];

  o.keys = self.s.from( o.keys );
  o.vals = self.s.from( o.vals );

  let keys = self.mapSrcFromSrc( o.keys );
  let vals = _.arrayFlattenOnce( null, o.vals );

  _.assert( _.arrayIs( keys ) );
  _.assert( _.arrayIs( vals ) );

  // if( o.vals && o.vals.length )
  // debugger;

  /* */

  for( let k = 0 ; k < keys.length ; k++ )
  {
    let key = keys[ k ];
    let res = o.result[ key ] = o.result[ key ] || [];
  }

  /* */

  for( let key in o.result )
  {
    let res = o.result[ key ];
    for( let v = 0 ; v < vals.length ; v++ )
    {
      let val = vals[ v ];
      if( _.strBegins( val, key ) )
      _.arrayAppendOnce( res, val );
    }

  }

  /* */

  // if( o.vals && o.vals.length )
  // debugger;

  return o.result;
}

group.defaults =
{
  keys : null,
  vals : null,
  result : null,
}

//

/*
qqq : teach common to work with path maps and cover it by tests
*/

function common()
{

  let paths = _.arrayFlatten( null, arguments );

  for( let s = 0 ; s < paths.length ; s++ )
  {
    if( _.mapIs( paths[ s ] ) )
    paths.splice( s, 1, _.mapKeys( paths[ s ] ) );
  }

  _.assert( _.strsAreAll( paths ) );

  if( !paths.length )
  return null;

  paths.sort( function( a,b )
  {
    return b.length - a.length;
  });

  let result = paths.pop();

  for( let i = 0, len = paths.length ; i < len ; i++ )
  result = this._commonPair( paths[ i ], result );

  return result;
}

//

function rebase( filePath, oldPath, newPath )
{

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  filePath = this.normalize( filePath );
  if( oldPath )
  oldPath = this.normalize( oldPath );
  newPath = this.normalize( newPath );

  if( oldPath )
  {
    let commonPath = this.common( filePath, oldPath );
    filePath = _.strRemoveBegin( filePath, commonPath );
  }

  filePath = this.reroot( newPath, filePath )

  return filePath;
}

// --
// textual reporter
// --

function groupTextualReport( o )
{
  let self = this;
  let r = '';
  let commonPath;

  _.routineOptions( groupTextualReport, arguments );
  o.verbosity = _.numberIs( o.verbosity ) ? o.verbosity : o.verbosity;

  if( o.verbosity >= 5 && o.groupsMap )
  r +=  _.toStr( o.groupsMap[ '/' ], { multiline : 1, wrap : 0, levels : 2 } ) + '\n';

  if( o.groupsMap )
  {
    commonPath = self.common( _.mapKeys( o.groupsMap ).filter( ( p ) => p !== '/' ) );
    if( o.verbosity >= 3 && o.groupsMap[ '/' ].length )
    r += '   ' + o.groupsMap[ '/' ].length + ' at ' + commonPath + '\n';
  }

  if( o.verbosity >= 3 && o.groupsMap )
  {
    let details = _.filter( o.groupsMap, ( filesPath, basePath ) =>
    {
      if( basePath === '/' )
      return;
      if( !filesPath.length )
      return;
      return '   ' + filesPath.length + ' at ' + self.dot( self.relative( commonPath, basePath ) );
    });
    if( _.mapVals( details ).length )
    r += _.mapVals( details ).join( '\n' ) + '\n';
  }

  if( o.verbosity >= 1 )
  {
    r += o.explanation + ( o.groupsMap ? o.groupsMap[ '/' ].length : 0 ) + ' file(s)';
    if( commonPath )
    r += ', at ' + commonPath;
    if( o.spentTime !== null )
    r += ', found in ' + _.timeSpentFormat( o.spentTime );
  }

  return r;
}

groupTextualReport.defaults =
{
  explanation : '',
  groupsMap : null,
  verbosity : 3,
  spentTime : null,
}

//

function commonTextualReport( filePath )
{

  if( _.mapIs( filePath ) )
  filePath = _.mapKeys( filePath );

  _.assert( _.strIs( filePath ) || _.arrayIs( filePath ) );
  _.assert( arguments.length === 1 );

  if( _.arrayIs( filePath ) && filePath.length === 0 )
  return '()';

  if( _.arrayIs( filePath ) && filePath.length === 1 )
  filePath = filePath[ 0 ];

  if( _.strIs( filePath ) )
  return filePath;

  let commonPath = this.common.apply( this, filePath );
  let relativePath = [];
  for( let i = 0 ; i < filePath.length ; i++ )
  relativePath[ i ] = this.relative( commonPath,filePath[ i ] );

  if( commonPath === '.' )
  return '[ ' + relativePath.join( ' , ' ) + ' ]';
  else
  return '( ' + commonPath + ' + ' + '[ ' + relativePath.join( ' , ' ) + ' ]' + ' )';
}

//

function moveTextualReport_pre( routine, args )
{

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { dstPath : args[ 0 ], srcPath : args[ 1 ] }

  _.routineOptions( routine, o );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 2 );

  return o;
}

function moveTextualReport_body( o )
{
  let result = '';

  _.assertRoutineOptions( moveTextualReport_body, arguments );

  let srcIsAbsolute = false;
  if( o.srcPath && this.s.anyAreAbsolute( o.srcPath ) )
  srcIsAbsolute = true;

  let dstIsAbsolute = false;
  if( o.dstPath && this.s.anyAreAbsolute( o.dstPath ) )
  dstIsAbsolute = true;

  if( !o.srcPath )
  o.srcPath = dstIsAbsolute ? '/{null}' : '{null}';
  if( !o.dstPath )
  o.dstPath = srcIsAbsolute ? '/{null}' : '{null}';

  if( dstIsAbsolute )
  if( o.srcPath === '' || o.srcPath === '.' )
  o.srcPath = '/{null}';

  // o.dstPath = o.dstPath || '{null}';
  // let c = this.isGlobal( o.srcPath ) ? '' : this.common( o.dstPath, o.srcPath );

  let common = this.common( o.dstPath, o.srcPath );

  if( o.decorating && _.color )
  {
    if( common.length > 1 )
    result = _.color.strFormat( common, 'path' ) + ' : ' + _.color.strFormat( this.relative( common, o.dstPath ), 'path' ) + ' <- ' + _.color.strFormat( this.relative( common, o.srcPath ), 'path' );
    else
    result = _.color.strFormat( o.dstPath, 'path' ) + ' <- ' + _.color.strFormat( o.srcPath, 'path' );
  }
  else
  {
    if( common.length > 1 )
    result = common + ' : ' + this.relative( common, o.dstPath ) + ' <- ' + this.relative( common, o.srcPath );
    else
    result = o.dstPath + ' <- ' + o.srcPath;
  }

  return result;
}

moveTextualReport_body.defaults =
{
  dstPath : null,
  srcPath : null,
  decorating : 1
}

let moveTextualReport = _.routineFromPreAndBody( moveTextualReport_pre, moveTextualReport_body );

// --
//
// --

function chainToRoot( filePath )
{
  let self = this;
  let result = [];

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( filePath ) );

  while( !self.isRoot( filePath ) )
  {
    result.unshift( self.detrail( filePath ) );
    filePath = self.dir( filePath );
  }

  return result;
}

// --
// exception
// --

function _onErrorNotSafe( prefix,filePath,level )
{
  _.assert( arguments.length === 3 );
  _.assert( _.strIs( prefix ) );
  _.assert( _.strIs( filePath ) || _.arrayIs( filePath ), 'Expects string or strings' );
  _.assert( _.numberIs( level ) );
  let args =
  [
    prefix + ( prefix ? '. ' : '' ),
    'Not safe to use file ' + _.strQuote( filePath ) + '.',
    'Please decrease {- safe -} if you know what you do,current {- safe = ' + level + ' -}'
  ];
  return args;
}

let ErrorNotSafe = _.error_functor( 'ErrorNotSafe', _onErrorNotSafe );

// --
// fields
// --

let Parameters = // xxx
{

  _rootStr : '/',
  _upStr : '/',
  _hereStr : '.',
  _downStr : '..',
  _hereUpStr : null,
  _downUpStr : null,

  _upEscapedStr : null,
  _downEscapedStr : null,
  _butDownUpEscapedStr : null,
  _delDownEscapedStr : null,
  _delDownEscapedNonEmptyStr : null,
  _delUpRegexp : null,
  _delHereRegexp : null,
  // _delHere1Regexp : null,
  // _delHere2Regexp : null,
  _delDownRegexp : null,
  _delDownFirstRegexp : null,
  _delUpDupRegexp : null,

}

let Fields =
{

  Parameters,

  fileProvider : null,
  path : Self,
  single : Self,
  s : null,

}

// --
// routines
// --

let Routines =
{

  // internal

  Init,
  CloneExtending,

  _pathMultiplicator_functor,
  _filterNoInnerArray,
  _filterOnlyPath,

  // path tester

  is,
  are,
  like,
  isSafe,
  isRefinedMaybeTrailed,
  isRefined,
  isNormalizedMaybeTrailed,
  isNormalized,
  isAbsolute,
  isRelative,
  isGlobal,
  isRoot,
  isDotted,
  isTrailed,
  isGlob,

  begins,
  ends,

  // reformer

  refine,

  _normalize,
  normalize,
  normalizeTolerant,
  normalizeCanonical,
  normalizeCanonicalTolerant,

  _pathNativizeWindows,
  _pathNativizeUnix,
  nativize,

  // transformer

  from,

  dot,
  undot,
  trail,
  detrail,

  dir,
  dirFirst,
  prefixGet,
  name,
  fullName,

  withoutExt,
  changeExt,
  ext,
  exts,

  // joiner

  join_body,

  join,
  joinRaw,
  joinIfDefined,
  joinCross,
  reroot,
  resolve,
  joinNames,

  _split,
  split,

  // stater

  current,

  // relator

  _relative,
  relative,
  relativeCommon,

  _commonPair,
  common,
  group,
  rebase,

  // textual reporter

  groupTextualReport,
  commonTextualReport,
  moveTextualReport,

  //

  chainToRoot, /* qqq : add basic test coverage */

  // exception

  ErrorNotSafe,

}

_.mapSupplement( Self,Parameters );
_.mapSupplement( Self,Fields );
_.mapSupplement( Self,Routines );

Self.Init();

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
{
  require( '../l4/Paths.s' );
  require( '../l7/Glob.s' );
}

})();
