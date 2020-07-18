( function _iCompose_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wModuleForTesting1;
let Self = _global_.wModuleForTesting1.compose = _global_.wModuleForTesting1.compose || Object.create( null );

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
// let Object.prototype.toString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

// --
// chainer
// --

function originaChainer( args, result, op, k )
{
  _.assert( result !== false );
  return args;
}

//

function originalWithDontChainer( args, result, op, k )
{
  _.assert( result !== false );
  // _.assert( result !== false && result !== undefined );
  if( result === _.dont )
  return _.dont;
  // return undefined;
  return args;
}

//

function composeAllChainer( args, result, op, k )
{
  _.assert( result !== false );
  // if( result === undefined )
  // return args;
  if( result === _.dont )
  return _.dont;
  // return undefined;
  // return _.unrollFrom( result );
  return args;
}

//

function chainingChainer( args, result, op, k )
{
  _.assert( result !== false );
  if( result === undefined )
  return args;
  if( result === _.dont )
  return _.dont;
  // return undefined;
  return _.unrollFrom( result );
  // return args;
}

// --
// supervisor
// --

function returningLastSupervisor( self, args, act, op )
{
  let result = act.apply( self, args );
  return result[ result.length-1 ];
}

//

function composeAllSupervisor( self, args, act, op )
{
  let result = act.apply( self, args );
  _.assert( !!result );
  if( !result.length )
  return result;
  if( result[ result.length-1 ] === _.dont )
  return false;
  if( !_.all( result ) )
  return false;
  return result;
}

//

function chainingSupervisor( self, args, act, op )
{
  let result = act.apply( self, args );
  if( result[ result.length-1 ] === _.dont )
  result.pop();
  return result;
}

// --
// declare
// --

let chainer =
{
  original : originaChainer,
  originalWithDont : originalWithDontChainer,
  composeAll : composeAllChainer,
  chaining : chainingChainer,
}

let supervisor =
{
  returningLast : returningLastSupervisor,
  composeAll : composeAllSupervisor,
  chaining : chainingSupervisor,
}

// --
// extend
// --

let Extension =
{

  chainer,
  supervisor

}

Object.assign( Self, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
