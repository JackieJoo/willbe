( function _gNumber_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wModuleForTesting1;
let Self = _global_.wModuleForTesting1;

let _ArrayIndexOf = Array.prototype.indexOf;
let _ArrayLastIndexOf = Array.prototype.lastIndexOf;
let _ArraySlice = Array.prototype.slice;
let _ArraySplice = Array.prototype.splice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;
let _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;
let _ceil = Math.ceil;
let _floor = Math.floor;

// --
// number
// --

function numbersTotal( numbers )
{
  let result = 0;
  _.assert( _.longIs( numbers ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  for( let n = 0 ; n < numbers.length ; n++ )
  {
    let number = numbers[ n ];
    _.assert( _.numberIs( number ) )
    result += number;
  }
  return result;
}

//

function numberFrom( src )
{
  _.assert( arguments.length === 1 );
  if( _.strIs( src ) )
  {
    return parseFloat( src );
  }
  return Number( src );
}

//

function numbersFrom( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( src ) )
  return _.numberFrom( src );

  if( _.numberIs( src ) )
  return src;

  let result;

  if( _.longIs( src ) )
  {
    result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _.numberFrom( src[ s ] );
  }
  else if( _.objectIs( src ) )
  {
    result = Object.create( null );
    for( let s in src )
    result[ s ] = _.numberFrom( src[ s ] );
  }
  else
  {
    result = _.numberFrom( src );
  }

  return result;
}

//

function numberFromStr( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) )
  let result = parseFloat( src );
  return result;
}

//

// function numberFromStrMaybe( src )
function numberFromStrMaybe( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) || _.numberIs( src ) );
  if( _.numberIs( src ) )
  return src;
  let parsed = Number( src );
  if( !isNaN( parsed ) )
  return parsed;
  return src;
}

//

function numbersSlice( src,f,l )
{
  if( _.numberIs( src ) )
  return src;
  return _.longSlice( src,f,l );
}

//

/**
 * The routine numberRandom() returns a random float number, the value of which is within a
 * range {-range-} .
 *
 * @param { Range|Number } range - The range for generating random numbers.
 * If {-range-} is number, routine generates random number from zero to provided value.
 *
 * @example
 * let got = _.numberRandom( 0 );
 * // returns random number in range [ 0, 0 ]
 * console.log( got );
 * // log 0
 *
 * @example
 * let got = _.numberRandom( 3 );
 * // returns random number in range [ 0, 3 ]
 * console.log( got );
 * // log 0.10161347203073712
 *
 * @example
 * let got = _.numberRandom( -3 );
 * // returns random number in range [ -3, 0 ]
 * console.log( got );
 * // log -1.4184648844870276
 *
 * @example
 * let got = _.numberRandom( [ 3, 3 ] );
 * console.log( got );
 * // log 3
 *
 * @example
 * let got = _.numberRandom( [ -3, 0 ] );
 * console.log( got );
 * // log -1.5699334307486583
 *
 * @example
 * let got = _.numberRandom( [ 0, 3 ] );
 * console.log( got );
 * // log 0.6154656826553855
 *
 * @example
 * let got = _.numberRandom( [ -3, 3 ] );
 * console.log( got );
 * // log 1.9835540787557022
 *
 * @returns { Number } - Returns a random float number.
 * @function numberRandom
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If range {-range-} is not a Number or not a Range.
 * @namespace ModuleForTesting1
 */

function numberRandom( range )
{

  if( _.numberIs( range ) )
  range = range >= 0 ? [ 0, range ] : [ range, 0 ];
  _.assert( arguments.length === 1 && _.rangeIs( range ), 'Expects range' );

  let result = Math.random()*( range[ 1 ] - range[ 0 ] ) + range[ 0 ];
  return result;
}

//

/**
 * The routine intRandom() returns a random integer number, the value of which is within a
 * range {-range-} .
 *
 * @param { Range|Number } range - The range for generating random numbers.
 * If {-range-} is number, routine generates random number from zero to provided value.
 *
 * @example
 * let got = _.intRandom( 0 );
 * // returns random number in range [ 0, 0 ]
 * console.log( got );
 * // log 0
 *
 * @example
 * let got = _.intRandom( 1 );
 * // returns random number in range [ 0, 1 ]
 * console.log( got );
 * // log 1
 *
 * @example
 * let got = _.intRandom( 3 );
 * // returns random number in range [ 0, 3 ]
 * console.log( got );
 * // log 1
 *
 * @example
 * let got = _.intRandom( -3 );
 * // returns random number in range [ -3, 0 ]
 * console.log( got );
 * // log -2
 *
 * @example
 * let got = _.intRandom( [ 3, 3 ] );
 * console.log( got );
 * // log 3
 *
 * @example
 * let got = _.intRandom( [ -3, 0 ] );
 * console.log( got );
 * // log -1
 *
 * @example
 * let got = _.intRandom( [ 0, 3 ] );
 * console.log( got );
 * // log 1
 *
 * @example
 * let got = _.intRandom( [ -3, 3 ] );
 * console.log( got );
 * // log -2
 *
 * @returns { Number } - Returns a random integer number.
 * @function intRandom
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If range {-range-} is not a Number or not a Range.
 * @namespace ModuleForTesting1
 */

function intRandom( range )
{

  if( _.numberIs( range ) )
  range = range >= 0 ? [ 0, range ] : [ range, 0 ];
  _.assert( arguments.length === 1 && _.rangeIs( range ), 'Expects range' );

  let result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );
  return result;
}

//

function intRandomBut( range )
{
  let result;
  let attempts = 50;

  if( _.numberIs( range ) )
  range = [ 0,range ];
  else if( _.arrayIs( range ) )
  range = range;
  else throw _.err( 'intRandom','unexpected argument' );

  for( let attempt = 0 ; attempt < attempts ; attempt++ )
  {
    // if( attempt === attempts-2 )
    // debugger;
    // if( attempt === attempts-1 )
    // debugger;

    /*result = _.intRandom( range ); */
    let result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );

    let bad = false;
    for( let a = 1 ; a < arguments.length ; a++ )
    if( _.routineIs( arguments[ a ] ) )
    {
      if( !arguments[ a ]( result ) )
      bad = true;
    }
    else
    {
      if( result === arguments[ a ] )
      bad = true;
    }

    if( bad )
    continue;
    return result;
  }

  result = NaN;
  return result;
}

//

function numbersMake( src,length )
{
  let result;

  if( _.vectorAdapterIs( src ) )
  src = _.vectorAdapter.slice( src );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( src ) || _.arrayLike( src ) );

  if( _.arrayLike( src ) )
  {
    _.assert( src.length === length );
    result = this.longMakeUndefined( length );
    for( let i = 0 ; i < length ; i++ )
    result[ i ] = src[ i ];
  }
  else
  {
    result = this.longMakeUndefined( length );
    for( let i = 0 ; i < length ; i++ )
    result[ i ] = src;
  }

  return result;
}

//

function numbersFromNumber( src,length )
{

  if( _.vectorAdapterIs( src ) )
  src = _.vectorAdapter.slice( src );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( src ) || _.arrayLike( src ) );

  if( _.arrayLike( src ) )
  {
    _.assert( src.length === length );
    return src;
  }

  // debugger; /* xxx2 : test */
  let result = this.longMakeUndefined( length );
  for( let i = 0 ; i < length ; i++ )
  result[ i ] = src;

  return result;
}

//

function numbersFromInt( dst,length )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.intIs( dst ) || _.arrayIs( dst ),'Expects array of number as argument' );
  _.assert( length >= 0 );

  if( _.numberIs( dst ) )
  {
    debugger;
    // dst = _.longFillTimes( [], length , dst );
    dst = _.longFill( [], dst, length );
  }
  else
  {
    for( let i = 0 ; i < dst.length ; i++ )
    _.assert( _.intIs( dst[ i ] ),'Expects integer, but got',dst[ i ] );
    _.assert( dst.length === length,'Expects array of length',length,'but got',dst );
  }

  return dst;
}

//

function numbersMake_functor( length )
{
  let _ = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( length ) );

  function numbersMake( src )
  {
    return _.numbersMake( src,length );
  }

  return numbersMake;
}

//

function numbersFrom_functor( length )
{
  let _ = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( length ) );

  function numbersFromNumber( src )
  {
    return _.numbersFromNumber( src,length );
  }

  return numbersFrom;
}

// --
// fields
// --

let Fields =
{
}

// --
// routines
// --

let Routines =
{

  numbersTotal,

  numberFrom,
  numbersFrom,
  numberFromStr,
  numberFromStrMaybe, /* qqq : cover */

  numbersSlice,

  numberRandom,
  intRandom,
  intRandomBut, /* dubious */

  numbersMake,
  numbersFromNumber,
  numbersFromInt,

  numbersMake_functor,
  numbersFrom_functor,

}

//

Object.assign( Self, Routines );
Object.assign( Self, Fields );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
