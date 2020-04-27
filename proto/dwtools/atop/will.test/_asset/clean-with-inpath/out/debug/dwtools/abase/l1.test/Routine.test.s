( function _Routine_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../Layer1.s' );
  _.include( 'wTesting' );
}

var _global = _global_;
var _ = _global_.wModuleForTesting1;

// --
// context
// --

function testFunction1( x, y )
{
  return x + y
}

function testFunction2( x, y )
{
  return this;
}

function testFunction3( x, y )
{
  return x + y + this.k;
}

function testFunction4( x, y )
{
  return this;
}

function contextConstructor3()
{
  this.k = 15
}

var context3 = new contextConstructor3();

// --
// test
// --

function routineIs( test )
{
  test.case = 'without argument';
  var got = _.routineIs();
  test.identical( got, false );

  test.case = 'check null';
  var got = _.routineIs( null );
  test.identical( got, false );

  test.case = 'check undefined';
  var got = _.routineIs( undefined );
  test.identical( got, false );

  test.case = 'check _.nothing';
  var got = _.routineIs( _.nothing );
  test.identical( got, false );

  test.case = 'false';
  var got = _.routineIs( false );
  test.identical( got, false );

  test.case = 'NaN';
  var got = _.routineIs( NaN );
  test.identical( got, false );

  test.case = 'Symbol';
  var got = _.routineIs( Symbol() );
  test.identical( got, false );

  test.case = 'array';
  var got = _.routineIs( [] );
  test.identical( got, false );

  test.case = 'arguments array';
  var got = _.routineIs( _.argumentsArrayMake( [] ) );
  test.identical( got, false );

  test.case = 'unroll';
  var got = _.routineIs( _.unrollMake( [] ) );
  test.identical( got, false );

  test.case = 'pure map';
  var got = _.routineIs( Object.create( null ) );
  test.identical( got, false );

  test.case = 'Set';
  var got = _.routineIs( new Set( [] ) );
  test.identical( got, false );

  test.case = 'Map';
  var got = _.routineIs( new Map( [] ) );
  test.identical( got, false );

  test.case = 'check BufferRaw';
  var got = _.routineIs( new BufferRaw() );
  test.identical( got, false );

  test.case = 'check BufferTyped';
  var got = _.routineIs( new U8x() );
  test.identical( got, false );

  test.case = 'number';
  var got = _.routineIs( 3 );
  test.identical( got, false );

  test.case = 'bigInt';
  var got = _.routineIs( 1n );
  test.identical( got, false );

  test.case = 'string';
  var got = _.routineIs( 'str' );
  test.identical( got, false );

  test.case = 'array';
  var got = _.routineIs( [ null ] );
  test.identical( got, false );

  test.case = 'map';
  var got = _.routineIs( { '' : null } );
  test.identical( got, false );

  test.case = 'check instance of constructor';
  var Constr = function(){ this.x = 1; return this };
  var src = new Constr();
  var got = _.routineIs( src );
  test.identical( got, false );

  test.case = 'check instance constructor';
  var Constr = function(){ this.x = 1; return this };
  var src = new Constr();
  var got = _.routineIs( src.constructor );
  test.identical( got, true );

  test.case = 'Object';
  var got = _.routineIs( Object );
  test.identical( got, true )

  test.case = 'arrow routine';
  var got = _.routineIs( () => {} );
  test.identical( got, true )

  test.case = 'unnamed routine';
  var got = _.routineIs( function (){} );
  test.identical( got, true )

  test.case = 'named routine';
  var got = _.routineIs( function a(){} );
  test.identical( got, true )

  test.case = 'async arrow routine';
  var got = _.routineIs( async () => {} );
  test.identical( got, true )

  test.case = 'async unnamed routine';
  var got = _.routineIs( async function (){} );
  test.identical( got, true )

  test.case = 'async named routine';
  var got = _.routineIs( async function a(){} );
  test.identical( got, true )
}

//

function routineLike( test )
{
  test.case = 'without argument';
  var got = _.routineLike();
  test.identical( got, false );

  test.case = 'check null';
  var got = _.routineLike( null );
  test.identical( got, false );

  test.case = 'check undefined';
  var got = _.routineLike( undefined );
  test.identical( got, false );

  test.case = 'check _.nothing';
  var got = _.routineLike( _.nothing );
  test.identical( got, false );

  test.case = 'false';
  var got = _.routineLike( false );
  test.identical( got, false );

  test.case = 'NaN';
  var got = _.routineLike( NaN );
  test.identical( got, false );

  test.case = 'Symbol';
  var got = _.routineLike( Symbol() );
  test.identical( got, false );

  test.case = 'array';
  var got = _.routineLike( [] );
  test.identical( got, false );

  test.case = 'arguments array';
  var got = _.routineLike( _.argumentsArrayMake( [] ) );
  test.identical( got, false );

  test.case = 'unroll';
  var got = _.routineLike( _.unrollMake( [] ) );
  test.identical( got, false );

  test.case = 'pure map';
  var got = _.routineLike( Object.create( null ) );
  test.identical( got, false );

  test.case = 'Set';
  var got = _.routineLike( new Set( [] ) );
  test.identical( got, false );

  test.case = 'Map';
  var got = _.routineLike( new Map( [] ) );
  test.identical( got, false );

  test.case = 'check BufferRaw';
  var got = _.routineLike( new BufferRaw() );
  test.identical( got, false );

  test.case = 'check BufferTyped';
  var got = _.routineLike( new U8x() );
  test.identical( got, false );

  test.case = 'number';
  var got = _.routineLike( 3 );
  test.identical( got, false );

  test.case = 'bigInt';
  var got = _.routineLike( 1n );
  test.identical( got, false );

  test.case = 'string';
  var got = _.routineLike( 'str' );
  test.identical( got, false );

  test.case = 'array';
  var got = _.routineLike( [ null ] );
  test.identical( got, false );

  test.case = 'map';
  var got = _.routineLike( { '' : null } );
  test.identical( got, false );

  test.case = 'check instance of constructor';
  var Constr = function(){ this.x = 1; return this };
  var src = new Constr();
  var got = _.routineLike( src );
  test.identical( got, false );

  test.case = 'check instance constructor';
  var Constr = function(){ this.x = 1; return this };
  var src = new Constr();
  var got = _.routineLike( src.constructor );
  test.identical( got, true );

  test.case = 'Object';
  var got = _.routineLike( Object );
  test.identical( got, true )

  test.case = 'arrow routine';
  var got = _.routineLike( () => {} );
  test.identical( got, true )

  test.case = 'unnamed routine';
  var got = _.routineLike( function (){} );
  test.identical( got, true )

  test.case = 'named routine';
  var got = _.routineLike( function a(){} );
  test.identical( got, true )

  test.case = 'async arrow routine';
  var got = _.routineLike( async () => {} );
  test.identical( got, true )

  test.case = 'async unnamed routine';
  var got = _.routineLike( async function (){} );
  test.identical( got, true )

  test.case = 'async named routine';
  var got = _.routineLike( async function a(){} );
  test.identical( got, true )
}

//

function routineIsPure( test )
{

  function sync1(){}
  function sync2(){}
  sync2.map = {};
  function async1(){}
  function async2(){}
  async2.map = {};

  var got = _.routineIsPure( 1 );
  test.identical( got, false )

  var got = _.routineIsPure( '' );
  test.identical( got, false )

  var got = _.routineIsPure( {} );
  test.identical( got, false )

  var got = _.routineIsPure( [] );
  test.identical( got, false )

  var got = _.routineIsPure( () => {} );
  test.identical( got, true )

  var got = _.routineIsPure( Object );
  test.identical( got, true )

  var got = _.routineIsPure( function () {} );
  test.identical( got, true )

  var got = _.routineIsPure( function a() {} );
  test.identical( got, true )

  var got = _.routineIsPure( async function () {} );
  test.identical( got, true )

  var got = _.routineIsPure( async () => {} );
  test.identical( got, true )

  var got = _.routineIsPure( async function a() {} );
  test.identical( got, true )

  var got = _.routineIsPure( sync1 );
  test.identical( got, true )

  var got = _.routineIsPure( sync2 );
  test.identical( got, true )

  var got = _.routineIsPure( async1 );
  test.identical( got, true )

  var got = _.routineIsPure( async2 );
  test.identical( got, true )

}

//

function routineIsSync( test )
{

  function sync1(){}
  function sync2(){}
  sync2.map = {};
  function async1(){}
  function async2(){}
  async2.map = {};

  var got = _.routineIsSync( 1 );
  test.identical( got, false )

  var got = _.routineIsSync( '' );
  test.identical( got, false )

  var got = _.routineIsSync( {} );
  test.identical( got, false )

  var got = _.routineIsSync( [] );
  test.identical( got, false )

  var got = _.routineIsSync( Object );
  test.identical( got, true )

  var got = _.routineIsSync( () => {} );
  test.identical( got, true )

  var got = _.routineIsSync( function () {} );
  test.identical( got, true )

  var got = _.routineIsSync( function a() {} );
  test.identical( got, true )

  var got = _.routineIsSync( async function () {} );
  test.identical( got, false )

  var got = _.routineIsSync( async () => {} );
  test.identical( got, false )

  var got = _.routineIsSync( async function a() {} );
  test.identical( got, false )

  var got = _.routineIs( sync1 );
  test.identical( got, true )

  var got = _.routineIs( sync2 );
  test.identical( got, true )

  var got = _.routineIs( async1 );
  test.identical( got, true )

  var got = _.routineIs( async2 );
  test.identical( got, true )

}

//

function routineIsAsync( test )
{

  function sync1(){}
  function sync2(){}
  sync2.map = {};
  function async1(){}
  function async2(){}
  async2.map = {};

  var got = _.routineIsAsync( 1 );
  test.identical( got, false )

  var got = _.routineIsAsync( '' );
  test.identical( got, false )

  var got = _.routineIsAsync( {} );
  test.identical( got, false )

  var got = _.routineIsAsync( [] );
  test.identical( got, false )

  var got = _.routineIsAsync( () => {} );
  test.identical( got, false )

  var got = _.routineIsAsync( Object );
  test.identical( got, false )

  var got = _.routineIsAsync( function () {} );
  test.identical( got, false )

  var got = _.routineIsAsync( function a() {} );
  test.identical( got, false )

  var got = _.routineIsAsync( async function () {} );
  test.identical( got, true )

  var got = _.routineIsAsync( async () => {} );
  test.identical( got, true )

  var got = _.routineIsAsync( async function a() {} );
  test.identical( got, true )

  var got = _.routineIs( sync1 );
  test.identical( got, true )

  var got = _.routineIs( sync2 );
  test.identical( got, true )

  var got = _.routineIs( async1 );
  test.identical( got, true )

  var got = _.routineIs( async2 );
  test.identical( got, true )

}

//

function _routineJoin( test )
{

  var testParam1 = 2,
    testParam2 = 4,
    options1 =
    {
      sealing : false,
      routine : testFunction1,
      args : [ testParam2 ], // x
      extending : true
    },
    options2 =
    {
      sealing : true,
      routine : testFunction2,
      args : [ testParam2 ], // x
      extending : true
    },

    options3 =
    {
      sealing : false,
      routine : testFunction3,
      args : [ testParam2 ], // x
      context : context3,
      extending : true
    },
    options4 =
    {
      sealing : false,
      routine : testFunction4,
      args : [ testParam2 ], // x
      context : context3,
      extending : true
    },

    options5 =
    {
      sealing : true,
      routine : testFunction3,
      args : [ testParam1, testParam2 ], // x
      context : context3,
      extending : true
    },

    wrongOpt1 = {
      sealing : true,
      routine : {},
      args : [ testParam1, testParam2 ], // x
      context : context3,
      extending : true
    },

    wrongOpt2 = {
      sealing : true,
      routine : testFunction3,
      args : 'wrong', // x
      context : context3,
      extending : true
    },

    expected1 = 6,
    expected2 = undefined,
    expected3 = 21,
    expected5 = 21;

  test.case = 'simple function without context with arguments bind without seal : result check';
  var gotfn = _._routineJoin( options1 );
  var got = gotfn( testParam1 );
  test.identical( got,expected1 );

  test.case = 'simple function without context and seal : context test';
  var gotfn = _._routineJoin(options2);
  var got = gotfn( testParam1 );
  test.identical( got, expected2 );

  test.case = 'simple function with context and arguments : result check';
  var gotfn = _._routineJoin(options3);
  var got = gotfn( testParam1 );
  test.identical( got, expected3 );

  test.case = 'simple function with context and arguments : context check';
  var gotfn = _._routineJoin(options4);
  var got = gotfn( testParam1 );
  test.identical( got instanceof contextConstructor3, true );

  test.case = 'simple function with context and arguments : result check, seal == true ';
  var gotfn = _._routineJoin(options5);
  var got = gotfn( testParam1 );
  test.identical( got, expected5 );

  test.case = 'simple function with context and arguments : result check, seal == true ';
  var gotfn = _._routineJoin(options5);
  var got = gotfn( 0,0 );
  test.identical( got, expected5 );

  test.case = 'extending';
  function srcRoutine(){}
  srcRoutine.defaults = { a : 10 };
  var gotfn = _.routineJoin( undefined, srcRoutine, [] );
  test.identical( gotfn.defaults, srcRoutine.defaults );

  /**/

  if( !Config.debug )
  return;

  test.case = 'missed argument';
  test.shouldThrowErrorSync( function()
  {
    _._routineJoin();
  });

  test.case = 'extra argument';
  test.shouldThrowErrorSync( function()
  {
    _._routineJoin( options1, options2 );
  });

  test.case = 'passed non callable object';
  test.shouldThrowErrorSync( function()
  {
    _._routineJoin( wrongOpt1 );
  });

  test.case = 'passed arguments as primitive value';
  test.shouldThrowErrorSync( function()
  {
    _._routineJoin( wrongOpt2 );
  });

};

//
//
// function routineBind( test )
// {
//
//   var testParam1 = 2,
//     testParam2 = 4,
//     expected1 = 6,
//     expected2 = undefined,
//     expected3 = 21;
//
//   test.case = 'simple function without context with arguments bind : result check';
//   var gotfn = _.routineBind( testFunction1, undefined, [ testParam2 ]);
//   var got = gotfn( testParam1 );
//   test.identical( got,expected1 );
//
//   test.case = 'simple function without /*ttt*/context test';
//   var gotfn = _.routineBind(testFunction2, undefined, [ testParam2 ]);
//   var got = gotfn( testParam1 );
//   test.identical( got, expected2 );
//
//   test.case = 'simple function with context and arguments : result check';
//   var gotfn = _.routineBind(testFunction3, context3, [ testParam2 ]);
//   var got = gotfn( testParam1 );
//   test.identical( got, expected3 );
//
//   test.case = 'simple function with context and arguments : context check';
//   var gotfn = _.routineBind(testFunction4, context3, [ testParam2 ]);
//   var got = gotfn( testParam1 );
//   test.identical( got instanceof contextConstructor3, true );
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed argument';
//   test.shouldThrowErrorSync( function()
//   {
//     _.routineBind();
//   });
//
//   test.case = 'extra argument';
//   test.shouldThrowErrorSync( function()
//   {
//     _.routineBind( testFunction4, context3, [ testParam2 ], [ testParam1 ] );
//   });
//
//   test.case = 'passed non callable object';
//   test.shouldThrowErrorSync( function()
//   {
//     _.routineBind( {}, context3, [ testParam2 ] );
//   });
//
//   test.case = 'passed arguments as primitive value';
//   test.shouldThrowErrorSync( function()
//   {
//     _.routineBind( testFunction4, context3, testParam2 );
//   });
//
// };

//

function constructorJoin( test )
{
  function srcRoutine()
  {
    var result =
    {
      context : this,
      args : _.longSlice( arguments )
    }
    return result;
  }
  srcRoutine.prop = true;

  /* */

  test.case = 'without args';
  var got = _.constructorJoin( srcRoutine );
  test.is( _.routineIs( got ) );
  var result = got();
  test.identical( _.mapKeys( srcRoutine ), [ 'prop' ] )
  test.identical( _.mapKeys( got ), [] );
  test.identical( result.args, [] );
  test.identical( result.context, srcRoutine );
  test.isNot( result.context instanceof srcRoutine );

  test.case = 'args - undefined';
  var got = _.constructorJoin( srcRoutine, undefined );
  test.is( _.routineIs( got ) );
  var result = got();
  test.identical( _.mapKeys( srcRoutine ), [ 'prop' ] )
  test.identical( _.mapKeys( got ), [] );
  test.identical( result.args, [] );
  test.identical( result.context, srcRoutine );
  test.isNot( result.context instanceof srcRoutine );

  test.case = 'args - null';
  var got = _.constructorJoin( srcRoutine, null );
  test.is( _.routineIs( got ) );
  var result = got();
  test.identical( _.mapKeys( srcRoutine ), [ 'prop' ] )
  test.identical( _.mapKeys( got ), [] );
  test.identical( result.args, [] );
  test.identical( result.context, srcRoutine );
  test.isNot( result.context instanceof srcRoutine );

  test.case = 'args - empty array';
  var args = [];
  var got = _.constructorJoin( srcRoutine, args );
  test.is( _.routineIs( got ) );
  var result = new got();
  test.identical( _.mapKeys( srcRoutine ), [ 'prop' ] )
  test.identical( _.mapKeys( got ), [] );
  test.identical( result.args, args );
  test.notIdentical( result.context, srcRoutine );
  test.is( result.context instanceof srcRoutine );

  test.case = 'args - array with map, returned routine exexute without arguments';
  var args = [ { a : 1 } ];
  var got = _.constructorJoin( srcRoutine, args );
  test.is( _.routineIs( got ) );
  var result = got();
  test.identical( _.mapKeys( srcRoutine ), [ 'prop' ] )
  test.identical( _.mapKeys( got ), [] );
  test.identical( result.args, args );
  test.identical( result.context, srcRoutine );
  test.isNot( result.context instanceof srcRoutine );

  test.case = 'args - array with map, returned routine exexute with arguments';
  var args = [ { a : 1 } ];
  var got = _.constructorJoin( srcRoutine, args );
  test.is( _.routineIs( got ) );
  var result = got({ b : 1 });
  test.identical( _.mapKeys( srcRoutine ), [ 'prop' ] )
  test.identical( _.mapKeys( got ), [] );
  test.identical( result.args, [ { a : 1 }, { b : 1 } ] );
  test.identical( result.context, srcRoutine );
  test.isNot( result.context instanceof srcRoutine );

  test.case = 'Array contructor, args = U8x buffer, execute without arguments';
  var args = new U8x( [ 1, 2, 3, 4 ] );
  var got = _.constructorJoin( Array, args );
  test.is( _.routineIs( got ) );
  var result = new got();
  test.identical( _.mapKeys( got ), [] );
  test.identical( result, [ 1, 2, 3, 4 ] );

  test.case = 'Array contructor, args = U8x buffer, exexute with number';
  var args = new U8x( [ 1, 2, 3, 4 ] );
  var got = _.constructorJoin( Array, args );
  test.is( _.routineIs( got ) );
  var result = new got( 1 );
  test.identical( _.mapKeys( got ), [] );
  test.identical( result, [ 1, 2, 3, 4, 1 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.constructorJoin() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.constructorJoin( Array, [ 1, 2 ], [ 1, 2 ] ) );

  test.case = 'wrong type of routine';
  test.shouldThrowErrorSync( () => _.constructorJoin( [], [] ) );

  test.case = 'wrong type of args';
  test.shouldThrowErrorSync( () => _.constructorJoin( srcRoutine, srcRoutine ) );
}

//

function routineJoin( test )
{
  function testFunction1( x, y ){ return this }
  function testFunction2( x, y ){ return x + y }
  function testFunction3( x, y ){ return x + y + ( this !== undefined ? this.k : 1 ) }
  function Constr(){ this.k = 15; return this }
  var context = new Constr();

  /* - */

  test.open( 'context - undefined, args - undefined' );

  test.case = 'named function without context, check context';
  var gotfn = _.routineJoin( undefined, testFunction1, undefined );
  test.identical( gotfn.name, 'testFunction1' );
  test.identical( gotfn.originalRoutine, testFunction1 );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, undefined );

  test.case = 'named function with arguments bind : result check';
  var gotfn = _.routineJoin( undefined, testFunction2, undefined );
  test.identical( gotfn.name, 'testFunction2' );
  test.identical( gotfn.originalRoutine, testFunction2 );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 5 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( undefined, testFunction3, undefined );
  test.identical( gotfn.name, 'testFunction3' );
  test.identical( gotfn.originalRoutine, testFunction3 );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 6 );

  test.case = 'unnamed function without context, check context';
  var gotfn = _.routineJoin( undefined, ( x, y ) => x + y, undefined );
  test.identical( gotfn.name, '' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => x + y )( 2, 3 ) );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 5 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( undefined, ( x, y ) => Math.pow( x, y ), undefined );
  test.identical( gotfn.name, '' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => Math.pow( x, y ) )( 2, 3 ) );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 8 );

  test.close( 'context - undefined, args - undefined' );

  /* - */

  test.open( 'context - undefined, args - long' );

  test.case = 'named function without context, check context';
  var gotfn = _.routineJoin( undefined, testFunction1, [ 4 ] );
  test.identical( gotfn.name, 'testFunction1' );
  test.identical( gotfn.originalRoutine, testFunction1 );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, undefined );

  test.case = 'named function with arguments bind : result check';
  var gotfn = _.routineJoin( undefined, testFunction2, [ 4 ] );
  test.identical( gotfn.name, 'testFunction2' );
  test.identical( gotfn.originalRoutine, testFunction2 );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, 6 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( undefined, testFunction3, [ 4 ] );
  test.identical( gotfn.name, 'testFunction3' );
  test.identical( gotfn.originalRoutine, testFunction3 );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 5 );
  test.identical( got, 10 );

  test.case = 'unnamed function without context, check context';
  var gotfn = _.routineJoin( undefined, ( x, y ) => x + y, [ 4 ] );
  test.identical( gotfn.name, '__joinedArguments' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => x + y )( 2, 3 ) );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, 6 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( undefined, ( x, y ) => Math.pow( x, y ), [ 4 ] );
  test.identical( gotfn.name, '__joinedArguments' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => Math.pow( x, y ) )( 2, 3 ) );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, 16 );

  test.close( 'context - undefined, args - long' );

  /* - */

  test.open( 'context - exists, args - undefined' );

  test.case = 'named function without context, check context';
  var gotfn = _.routineJoin( context, testFunction1, undefined );
  test.identical( gotfn.name, 'bound testFunction1' );
  test.identical( gotfn.originalRoutine, testFunction1 );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got instanceof Constr, true );

  test.case = 'named function with arguments bind : result check';
  var gotfn = _.routineJoin( context, testFunction2, undefined );
  test.identical( gotfn.name, 'bound testFunction2' );
  test.identical( gotfn.originalRoutine, testFunction2 );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 5 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( context, testFunction3, undefined );
  test.identical( gotfn.name, 'bound testFunction3' );
  test.identical( gotfn.originalRoutine, testFunction3 );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 20 );

  test.case = 'unnamed function without context, check context';
  var gotfn = _.routineJoin( context, ( x, y ) => x + y, undefined );
  test.identical( gotfn.name, 'bound ' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => x + y )( 2, 3 ) );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 5 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( context, ( x, y ) => Math.pow( x, y ), undefined );
  test.identical( gotfn.name, 'bound ' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => Math.pow( x, y ) )( 2, 3 ) );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, undefined );
  var got = gotfn( 2, 3 );
  test.identical( got, 8 );

  test.close( 'context - exists, args - undefined' );

  /* - */

  test.open( 'context - exists, args - long' );

  test.case = 'named function without context, check context';
  var gotfn = _.routineJoin( context, testFunction1, [ 4 ] );
  test.identical( gotfn.name, 'bound testFunction1' );
  test.identical( gotfn.originalRoutine, testFunction1 );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got instanceof Constr, true );

  test.case = 'named function with arguments bind : result check';
  var gotfn = _.routineJoin( context, testFunction2, [ 4 ] );
  test.identical( gotfn.name, 'bound testFunction2' );
  test.identical( gotfn.originalRoutine, testFunction2 );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, 6 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( context, testFunction3, [ 4 ] );
  test.identical( gotfn.name, 'bound testFunction3' );
  test.identical( gotfn.originalRoutine, testFunction3 );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 5 );
  test.identical( got, 24 );

  test.case = 'unnamed function without context, check context';
  var gotfn = _.routineJoin( context, ( x, y ) => x + y, [ 4 ] );
  test.identical( gotfn.name, 'bound ' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => x + y )( 2, 3 ) );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, 6 );

  test.case = 'unnamed function with arguments bind : result check';
  var gotfn = _.routineJoin( context, ( x, y ) => Math.pow( x, y ), [ 4 ] );
  test.identical( gotfn.name, 'bound ' );
  test.identical( gotfn.originalRoutine( 2, 3 ), ( ( x, y ) => Math.pow( x, y ) )( 2, 3 ) );
  test.identical( gotfn.boundContext, context );
  test.identical( gotfn.boundArguments, [ 4 ] );
  var got = gotfn( 2 );
  test.identical( got, 16 );

  test.close( 'context - exists, args - long' );

  /* - */

  test.case = 'extending'
  var srcRoutine = function(){};
  srcRoutine.defaults = { a : 10 };
  var gotfn = _.routineJoin( undefined, srcRoutine, [] );
  test.identical( gotfn.defaults, srcRoutine.defaults );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.routineJoin() );

  test.case = 'extra argument';
  test.shouldThrowErrorSync( () => _.routineJoin( undefined, testFunction4, [ 4 ], [ 2 ] ) );

  test.case = 'wrong type of routine';
  test.shouldThrowErrorSync( () => _.routineJoin( undefined, 1, [ 4 ] ) );
  test.shouldThrowErrorSync( () => _.routineJoin( undefined, {}, [ 4 ] ) );

  test.case = 'wrong type of args';
  test.shouldThrowErrorSync( () => _.routineJoin( undefined, testFunction4, 4 ) );
  test.shouldThrowErrorSync( () => _.routineJoin( undefined, testFunction4, null ) );
}

//

function routineSeal(test)
{

  var testParam1 = 2,
    testParam2 = 4,
    expected1 = 6,
    expected2 = undefined,
    expected3 = 21;

  test.case = 'simple function with seal arguments : result check';
  var gotfn = _.routineSeal(undefined, testFunction1, [testParam1, testParam2]);
  var got = gotfn( testParam1 );
  test.identical( got, expected1 );

  test.case = 'simple function with seal arguments : context check';
  var gotfn = _.routineSeal(undefined, testFunction2, [testParam1, testParam2]);
  var got = gotfn( testParam1 );
  test.identical( got, expected2 );

  test.case = 'simple function with seal context and arguments : result check';
  var gotfn = _.routineSeal(context3, testFunction3, [testParam1, testParam2]);
  var got = gotfn( testParam1 );
  test.identical( got, expected3 );

  test.case = 'simple function with seal context and arguments : context check';
  var gotfn = _.routineSeal(context3, testFunction4, [testParam1, testParam2]);
  var got = gotfn( testParam1 );
  test.identical( got instanceof contextConstructor3, true );

  test.case = 'simple function with seal context and arguments : result check';
  var gotfn = _.routineSeal(context3, testFunction3, [testParam1, testParam2]);
  var got = gotfn( 0,0 );
  test.identical( got, expected3 );

  test.case = 'extending';
  function srcRoutine(){}
  srcRoutine.defaults = { a : 10 };
  var gotfn = _.routineJoin( undefined, srcRoutine, [] );
  test.identical( gotfn.defaults, srcRoutine.defaults );

  if( !Config.debug )
  return;

  test.case = 'missed argument';
  test.shouldThrowErrorSync( function()
  {
    _.routineSeal();
  });

  test.case = 'extra argument';
  test.shouldThrowErrorSync( function()
  {
    _.routineSeal( context3, testFunction4, [ testParam2 ], [ testParam1 ] );
  });

  test.case = 'passed non callable object';
  test.shouldThrowErrorSync( function()
  {
    _.routineSeal( context3, {}, [ testParam1, testParam2 ] );
  });

  test.case = 'passed arguments as primitive value';
  test.shouldThrowErrorSync( function()
  {
    _.routineSeal( context3, testFunction4, testParam2 );
  });

}

//

function routinesCompose( test )
{

  function routineUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    return _.unrollAppend( _.unrollMake( null ), _.unrollMake( arguments ), counter );
  }

  function routineNotUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    // return _.arrayAppend_( result, counter );
    let result = _.arrayAppendArrays( null, arguments );
    return _.arrayAppend( result, counter );
  }

  function r2()
  {
    counter += 100;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += 2*arguments[ a ];
    return counter;
  }

  function _break()
  {
    return _.dont;
  }

  function chainer1( args, result, o, k )
  {
    return result;
  }

  /* - */

  test.case = 'empty';

  var counter = 0;
  var routines = [];
  var composition = _.routinesCompose( routines );
  var got = composition( 1,2,3 );
  var expected = [];
  test.identical( got, expected );
  test.identical( counter, 0 );

  /* - */

  test.open( 'unrolling:1' )

  /* */

  test.case = 'without chainer';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, r2, null ];
  var composition = _.routinesCompose( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16,128 ];
  test.identical( got, expected );
  test.identical( counter, 128 );

  /* */

  test.case = 'with chainer';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, r2, null ];
  var composition = _.routinesCompose( routines, chainer1 );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16,160 ];
  test.identical( got, expected );
  test.identical( counter, 160 );

  /* */

  test.case = 'with chainer and break';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _break, null, r2, null ];
  var composition = _.routinesCompose( routines, chainer1 );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16,_.dont ];
  test.identical( got, expected );
  test.identical( counter, 16 );

  /* */

  test.close( 'unrolling:1' )

  /* - */

  test.open( 'unrolling:0' )

  /* */

  test.case = 'without chainer';

  var counter = 0;
  var routines = [ null, routineNotUnrolling, null, r2, null ];
  var composition = _.routinesCompose( routines );
  var got = composition( 1,2,3 );
  var expected = [ [ 1,2,3,16 ], 128 ];
  test.identical( got, expected );
  test.identical( counter, 128 );

  /* */

  test.case = 'with chainer';

  var counter = 0;
  var routines = [ null, routineNotUnrolling, null, r2, null ];
  var composition = _.routinesCompose( routines, chainer1 );
  var got = composition( 1,2,3 );
  var expected = [ [ 1,2,3,16 ], 160 ];
  test.identical( got, expected );
  test.identical( counter, 160 );

  /* */

  test.case = 'with chainer and break';

  var counter = 0;
  var routines = [ null, routineNotUnrolling, null, _break, null, r2, null ];
  var composition = _.routinesCompose( routines, chainer1 );
  var got = composition( 1,2,3 );
  var expected = [ [ 1,2,3,16 ],_.dont ];
  test.identical( got, expected );
  test.identical( counter, 16 );

  /* */

  test.close( 'unrolling:0' )

  /* - */

  if( !Config.debug )
  return;

  test.case = 'bad arguments';

  test.shouldThrowErrorSync( () => _.routinesComposeAll() );
  test.shouldThrowErrorSync( () => _.routinesComposeAll( routines, function(){}, function(){} ) );

}

//

function routinesComposeAll( test )
{

  function routineUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    return _.unrollAppend( _.unrollMake( null ), _.unrollMake( arguments ), counter );
  }

  function routineNotUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    // return _.arrayAppend_( null, arguments, counter );
    let result = _.arrayAppendArrays( null, arguments );
    return _.arrayAppend( result, counter );
  }

  function r2()
  {
    counter += 100;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += 2*arguments[ a ];
    return counter;
  }

  function _nothing()
  {
    return undefined;
  }

  function _dont()
  {
    return _.dont;
  }

  test.case = 'with nothing';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _nothing, null, r2, null ];
  var composition = _.routinesComposeAll( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16,128 ];
  test.identical( got, expected );
  test.identical( counter, 128 );

  test.case = 'last nothing';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _nothing ];
  var composition = _.routinesComposeAll( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16 ];
  test.identical( got, expected );
  test.identical( counter, 16 );

  test.case = 'not unrolling and last nothing';

  var counter = 0;
  var routines = [ null, routineNotUnrolling, null, _nothing ];
  var composition = _.routinesComposeAll( routines );
  var got = composition( 1,2,3 );
  var expected = [ [ 1,2,3,16 ] ];
  test.identical( got, expected );
  test.identical( counter, 16 );

  test.case = 'with nothing and dont';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _nothing, null, _dont, null, r2, null ];
  var composition = _.routinesComposeAll( routines );
  var got = composition( 1,2,3 );
  var expected = false;
  test.identical( got, expected );
  test.identical( counter, 16 );

  if( !Config.debug )
  return;

  test.case = 'bad arguments';

  test.shouldThrowErrorSync( () => _.routinesComposeAll() );
  test.shouldThrowErrorSync( () => _.routinesComposeAll( routines, function(){} ) );
  test.shouldThrowErrorSync( () => _.routinesComposeAll( routines, function(){}, function(){} ) );

}

//

function routinesComposeAllReturningLast( test )
{

  function routineUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    return _.unrollAppend( _.unrollMake( null ), _.unrollMake( arguments ), counter );
  }

  function routineNotUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    // return _.arrayAppend_( null, arguments, counter );
    let result = _.arrayAppendArrays( null, arguments );
    return _.arrayAppend( result, counter );
  }

  function r2()
  {
    counter += 100;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += 2*arguments[ a ];
    return counter;
  }

  function _nothing()
  {
    return undefined;
  }

  function _dont()
  {
    return _.dont;
  }

  test.case = 'with nothing';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _nothing, null, r2, null ];
  var composition = _.routinesComposeAllReturningLast( routines );
  var got = composition( 1,2,3 );
  var expected = 128;
  test.identical( got, expected );
  test.identical( counter, 128 );

  test.case = 'last nothing';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _nothing ];
  var composition = _.routinesComposeAllReturningLast( routines );
  var got = composition( 1,2,3 );
  var expected = 16;
  test.identical( got, expected );
  test.identical( counter, 16 );

  test.case = 'not unrolling and last nothing';

  var counter = 0;
  var routines = [ null, routineNotUnrolling, null, _nothing ];
  var composition = _.routinesComposeAllReturningLast( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16 ];
  test.identical( got, expected );
  test.identical( counter, 16 );

  test.case = 'with nothing and dont';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _nothing, null, _dont, null, r2, null ];
  var composition = _.routinesComposeAllReturningLast( routines );
  var got = composition( 1,2,3 );
  var expected = _.dont;
  test.identical( got, expected );
  test.identical( counter, 16 );

  if( !Config.debug )
  return;

  test.case = 'bad arguments';

  test.shouldThrowErrorSync( () => _.routinesComposeAllReturningLast() );
  test.shouldThrowErrorSync( () => _.routinesComposeAllReturningLast( routines, function(){} ) );
  test.shouldThrowErrorSync( () => _.routinesComposeAllReturningLast( routines, function(){}, function(){} ) );

}

//

function routinesChain( test )
{

  function routineUnrolling()
  {
    counter += 10;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += arguments[ a ];
    return _.unrollAppend( _.unrollMake( null ), _.unrollMake( arguments ), counter );
  }

  function r2()
  {
    counter += 100;
    for( var a = 0 ; a < arguments.length ; a++ )
    counter += 2*arguments[ a ];
    return counter;
  }

  function _break()
  {
    return _.dont;
  }

  function dontInclude()
  {
    return undefined;
  }

  /* */

  test.case = 'without break';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, r2, null ];
  var composition = _.routinesChain( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16,160 ];
  test.identical( got, expected );
  test.identical( counter, 160 );

  /* */

  test.case = 'with break';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, _break, null, r2, null ];
  var composition = _.routinesChain( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16 ];
  test.identical( got, expected );
  test.identical( counter, 16 );

  /* */

  test.case = 'with dont include';

  var counter = 0;
  var routines = [ null, routineUnrolling, null, dontInclude, null, r2, null ];
  var composition = _.routinesChain( routines );
  var got = composition( 1,2,3 );
  var expected = [ 1,2,3,16, 160 ];
  test.identical( got, expected );
  test.identical( counter, 160 );

  if( !Config.debug )
  return;

  test.case = 'bad arguments';

  test.shouldThrowErrorSync( () => _.routinesComposeAll() );
  test.shouldThrowErrorSync( () => _.routinesComposeAll( routines, function(){} ) );
  test.shouldThrowErrorSync( () => _.routinesComposeAll( routines, function(){}, function(){} ) );

}

//

function routineExtend( test )
{

  test.open( 'dst is null, src has pre and body properties');

  test.case = 'dst is null, src is routine maked by routineFromPreAndBody';
  var got = _.routineExtend( null, _.routineFromPreAndBody );
  test.identical( got.pre, _.routineFromPreAndBody.pre );
  test.identical( got.body, _.routineFromPreAndBody.body );
  test.identical( typeof got, 'function' );

  var got = _.routineExtend( null, _.routinesCompose );
  test.identical( got.pre, _.routinesCompose.pre );
  test.identical( got.body, _.routinesCompose.body );
  test.identical( typeof got, 'function' );

  function f1(){}
  f1.map1 = {};
  f1.map1.a = 1;
  f1.map2 = Object.create( {} );
  f1.map2.a = 2;
  f1.str = 'str';
  f1.number = 13;
  f1.routine = function r(){};

  var got = _.routineExtend( null, f1 );
  test.equivalent( got.map1, f1.map1 );
  test.equivalent( got.map2, f1.map2 );
  test.equivalent( got.str, f1.str );
  test.equivalent( got.number, f1.number );
  test.equivalent( got.routine, f1.routine );

  test.case = 'second arg has not pre and body properties';
  var got = _.routineExtend( null, _.unrollIs );
  test.is( _.routineIs( got ) );
  test.is( got( _.unrollFrom( [] ) ) );

  test.case = 'dst is null, src is map with pre and body properties';
  var src =
  {
    pre : _.routineFromPreAndBody.pre,
    body : _.routineFromPreAndBody.body,
    map : { a : 2 },
  }
  var got = _.routineExtend( null, src );
  test.identical( got.pre, _.routineFromPreAndBody.pre );
  test.identical( got.body, _.routineFromPreAndBody.body );
  test.equivalent( got.map, { a : 2 } );
  test.identical( typeof got, 'function' );

  test.case = 'dst is null, src is map with pre and body properties';
  var src =
  {
    pre : _.routineFromPreAndBody.pre,
    body : _.routineFromPreAndBody.body,
    map : { a : 2 },
  };
  var got = _.routineExtend( null, src );
  test.identical( got.pre, _.routineFromPreAndBody.pre );
  test.identical( got.body, _.routineFromPreAndBody.body );
  test.equivalent( got.map, { a : 2 } );
  test.identical( typeof got, 'function' );

  test.case = 'dst is null, src is map with pre and body properties';
  var src =
  {
    pre : _.routineFromPreAndBody.pre,
    body : _.routineFromPreAndBody.body,
    a : [ 1 ],
    b : 'str',
    c : { str : 'str' }
  }
  var got = _.routineExtend( null, src );
  test.identical( got.pre, _.routineFromPreAndBody.pre );
  test.identical( got.body, _.routineFromPreAndBody.body );
  test.identical( got.a, [ 1 ] );
  test.identical( got.b, 'str' );
  test.identical( got.c, Object.create( { str : 'str' } ) );
  test.identical( typeof got, 'function' );

  test.close( 'dst is null, src has pre and body properties');

  /* - */

  test.open( 'single dst');

  test.case = 'single dst';
  var dst = function( o )
  {
  }
  var got = _.routineExtend( dst );
  test.identical( got, dst );
  test.identical( typeof got, 'function' );

  test.case = 'single dst is routine, has properties';
  var dst = function( o )
  {
  };
  dst.a = 0;
  dst.b = 3;
  dst.c = 'c';
  var got = _.routineExtend( dst );
  test.identical( got, dst );
  test.identical( typeof got, 'function' );
  test.identical( got.a, 0 );
  test.identical( got.b, 3 );
  test.identical( got.c, 'c' );

  test.case = 'single dst is routine, has hiden properties';
  var dst = function( o )
  {
  };
  Object.defineProperties( dst,
  {
    'a' :
    {
      value : 0,
      enumerable : true,
      writable : false,
    },
    'b' :
    {
      value : { a : 2 },
      enumerable : false,
      writable : false,
    }
  });
  var got = _.routineExtend( dst );
  test.identical( got, dst );
  test.identical( typeof got, 'function' );
  test.identical( got.a, 0 );
  test.identical( got.b, { a : 2 } );
  var got = Object.getOwnPropertyDescriptor( got, 'b' );
  test.isNot( got.enumerable );

  test.close( 'single dst');

  test.case = 'dst has properties, src map has different properties';
  var dst = function( o )
  {
  };
  dst.a = 0;
  dst.b = 0;
  var got = _.routineExtend( dst, { c : 1, d : 1, e : { s : 1 } } );
  test.identical( typeof got, 'function' );
  test.identical( got.a, 0 );
  test.identical( got.b, 0 );
  test.identical( got.c, 1 );
  test.identical( got.e, Object.create( { s : 1 } ) );

  test.case = 'dst has properties, src map has the same properties';
  var dst = function( o )
  {
  };
  dst.a = 0;
  dst.b = 0;
  var got = _.routineExtend( dst, { a: 1, b : 1 } );
  test.identical( typeof got, 'function' );
  test.identical( got.a, 1 );
  test.identical( got.b, 1 );

  /* */

  test.case = 'dst has non-writable properties';
  var dst = function( o )
  {
  };
  Object.defineProperties( dst,
  {
    'a' :
    {
      enumerable : true,
      writable : false,
      value : 0,
    },
    'b' :
    {
      enumerable : true,
      writable : false,
      value : 0,
    }
  });
  var got = _.routineExtend( dst, { a: 3, b : 2 } );
  test.identical( typeof got, 'function' );
  test.identical( got.a, 0 );
  test.identical( got.b, 0 );

  test.case = 'src has non-writable properties';
  var dst = function( o )
  {
  };
  dst.a = 0;
  dst.b = 0;
  var src = {};
  Object.defineProperties( src,
  {
    'a' :
    {
      enumerable : true,
      writable : false,
      value : 3,
    },
    'b' :
    {
      enumerable : true,
      writable : false,
      value : 2,
    }
  });
  var got = _.routineExtend( dst, src );
  test.identical( typeof got, 'function' );
  test.identical( got.a, 3 );
  test.identical( got.b, 2 );

  test.case = 'src is an array';
  test.shouldThrowErrorSync( () =>
  {
    var dst = function( o )
    {
    };
    var got = _.routineExtend( dst, [ 'a', 1 ] );
    test.identical( typeof got, 'function' );
    test.identical( got[ 0 ], 'a' );
    test.identical( got[ 1 ], 1 );
  });

  test.open( 'few extends');

  test.case = 'null extends other routine, null extends result';
  var src = _.routineExtend( null, _.routinesCompose );
  var got = _.routineExtend( null, src );
  test.identical( got.pre, _.routinesCompose.pre );
  test.identical( got.body, _.routinesCompose.body );
  test.identical( typeof got, 'function' );

  test.case = 'src extends routine, result extends map ';
  var src1 =
  {
    pre : _.routineFromPreAndBody.pre,
    body : _.routineFromPreAndBody.body,
    a : 'str',
    b : { b : 3 },
  };
  var src = _.routineExtend( null, _.routinesCompose );
  var got = _.routineExtend( src, src1 );
  test.identical( got.pre, _.routineFromPreAndBody.pre );
  test.identical( got.body, _.routineFromPreAndBody.body );
  test.identical( got.b, Object.create( { b : 3 } ) );
  test.is( got.a === 'str' );
  test.identical( typeof got, 'function' );

  test.case = 'dst extends map, dst extends other map';
  var dst = function()
  {
  };
  var src1 =
  {
    pre : _.routinesCompose.pre,
    body : _.routinesCompose.body,
    a : ['str'],
    c : { d : 2 },
  };
  var src = _.routineExtend( dst, { c : {}, b : 'str' } );
  var got = _.routineExtend( dst, src1 );
  test.identical( got.pre, _.routinesCompose.pre );
  test.identical( got.body, _.routinesCompose.body );
  test.identical( got.a, [ 'str' ] );
  test.identical( got.b, 'str' );
  test.identical( got.c, Object.create( { d : 2 } ) );
  test.identical( typeof got, 'function' );

  test.case = 'dst has map property, dst extends other map';
  var dst = function()
  {
  };
  dst.map = { a : 'str' };
  var src1 =
  {
    pre : _.routinesCompose.pre,
    body : _.routinesCompose.body,
    a : ['str'],
    map : { d : 2 },
  };
  var src = _.routineExtend( dst, { c : {} } );
  var got = _.routineExtend( dst, src1 );
  test.identical( got.pre, _.routinesCompose.pre );
  test.identical( got.body, _.routinesCompose.body );
  test.identical( got.a, [ 'str' ] );
  var expectedMap = Object.create( { d : 2 } );
  expectedMap.a = 'str';
  test.identical( got.map, expectedMap );
  test.identical( got.c, {} );
  test.identical( typeof got, 'function' );

  test.case = 'dst extends routine1, src extends routine, dst extends src';
  var dst = function()
  {
  };
  var src = function()
  {
  };
  var routine = function()
  {
  };
  routine.a = 0;
  routine.b = [ 'str' ];
  var routine1 = function()
  {
  };
  routine1.a = 2;
  routine1.c = 'str';
  var src1 = _.routineExtend( src, routine );
  var src2 = _.routineExtend( dst, routine1 );
  var got = _.routineExtend( src2, src1 )
  test.identical( got.a, 0 );
  test.identical( got.b, [ 'str' ] );
  test.identical( got.c, 'str' );
  test.identical( dst.a, got.a );
  test.identical( dst.b, got.b );
  test.identical( dst.c, got.c );
  test.identical( typeof got, 'function' );

  test.case = 'dst extends map, src extends map, dst extends src';
  var dst = function()
  {
  };
  var src = function()
  {
  };
  var src1 = _.routineExtend( src, { o1 : 1, o2 : 'str' } );
  var src2 = _.routineExtend( dst, { o3 : 'o3', o1 : 'map'} );
  var got = _.routineExtend( src2, src1 )
  test.identical( got.o1, 1 );
  test.identical( got.o2, 'str' );
  test.identical( got.o3, 'o3' );
  test.identical( dst.a, got.a );
  test.identical( dst.b, got.b );
  test.identical( dst.c, got.c );
  test.identical( typeof got, 'function' );

  test.case = 'extend by map';
  var dst = function()
  {
  };
  Object.defineProperties( dst, {
    'b' : {
      value : { a : 2 },
      enumerable : true,
      writable : true,
    }
  });
  var got = _.routineExtend( dst );
  test.equivalent( got.b, { a : 2 } );

  test.case = 'extend by map';
  var dst = function( o )
  {
  };
  dst.b = { map : 2 };
  var got = _.routineExtend( dst, { b : { map : 3 } } );
  test.equivalent( got.b, { map : 3 } );

  test.close( 'few extends');

  if( !Config.debug )
  return;

  test.case = 'no arguments';
  test.shouldThrowErrorSync( function()
  {
    _.routineExtend();
  });

  test.case = 'three arguments';
  test.shouldThrowErrorSync( function()
  {
    _.routineExtend( null, { a : 1 }, { b : 2 });
  });

  test.case = 'single dst is null';
  test.shouldThrowErrorSync( function()
  {
    _.routineExtend( null );
  });

  // test.case = 'second arg has not pre and body properties';
  // test.shouldThrowErrorSync( function()
  // {
  //   _.routineExtend( null, _.unrollIs );
  // });

  test.case = 'second arg is primitive';
  test.shouldThrowErrorSync( function()
  {
    _.routineExtend( _.unrollIs, 'str' );
  });

  test.shouldThrowErrorSync( function()
  {
    _.routineExtend( _.unrollIs, 1 );
  });

  test.case = 'dst is not routine or null';
  test.shouldThrowErrorSync( function()
  {
    _.routineExtend( 1, { a : 1 } );
  });

  test.shouldThrowErrorSync( function()
  {
    _.routineExtend( 'str', { a : 1 } );
  });

}

//

function routineDefaults( test )
{

  test.case = 'make new routine';

  function add1_pre( routine, args )
  {
    return _.routineOptions( routine, args );
  }
  function add1_body( o )
  {
    o = _.assertRoutineOptions( add1, arguments );
    return o.a + o.b;
  }
  add1_body.defaults =
  {
    a : 1,
    b : 3,
  }
  let add1 = _.routineFromPreAndBody( add1_pre, add1_body );

  test.description = 'control call';
  var got = add1();
  test.identical( got, 4 );

  test.description = 'generate';
  let add2 = _.routineDefaults( null, add1, { b : 5 } );
  test.is( add1 !== add2 );
  test.is( add1.defaults !== add2.defaults );
  test.is( _.mapLike( add1.defaults ) );
  test.is( _.mapLike( add2.defaults ) );
  test.is( add1.defaults.b === 3 );
  test.is( add2.defaults.b === 5 );

  test.description = 'trivial call';
  var got = add2();
  test.identical( got, 6 );

  /* */

  test.case = 'adjust routine defaults';

  function add3_pre( routine, args )
  {
    return _.routineOptions( routine, args );
  }
  function add3_body( o )
  {
    o = _.assertRoutineOptions( add1, arguments );
    return o.a + o.b;
  }
  add3_body.defaults =
  {
    a : 1,
    b : 3,
  }
  let add3 = _.routineFromPreAndBody( add3_pre, add3_body );

  test.description = 'control call';
  var got = add3();
  test.identical( got, 4 );

  test.description = 'generate';
  let add4 = _.routineDefaults( add3, { b : 5 } );
  test.is( add3 === add4 );
  test.is( add3.defaults === add4.defaults );
  test.is( _.mapLike( add3.defaults ) );
  test.is( _.mapLike( add4.defaults ) );
  test.is( add3.defaults.b === 5 );
  test.is( add4.defaults.b === 5 );

  test.description = 'trivial call';
  var got = add4();
  test.identical( got, 6 );

}

//

function vectorizeVectorizeArray( test )
{
  var srcRoutine = function()
  {
    if( arguments.length === 0 )
    return null;
    return _.longSlice( arguments );
  };

  /* */

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'without arguments';
  var got = routine();
  test.identical( got, null );

  test.case = 'single argument';
  var src = 1;
  var got = routine( src );
  test.identical( got, [ 1 ] );
  test.is( got !== src );

  test.case = 'multiply arguments';
  var src = 1;
  var got = routine( src, 0 );
  test.identical( got, [ 1, 0 ] );
  test.is( got !== src );

  /* - */

  test.open( 'array' );

  test.case = 'single argument';

  var src = [ 1 ];
  var got = routine( src );
  test.identical( got, [ [ 1 ] ] );
  test.is( got !== src );

  var src = [ 1, 2, 3 ];
  var got = routine( src );
  test.identical( got, [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = [ 1, 2 ,3 ];
  var got = routine( src, 2 );
  test.identical( got, [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = 2;
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( got, [ 2, [ 1, 2, 3 ] ] );
  test.is( got !== src );

  var src = [ 1, 2 ];
  var got = routine( src, [ 3, 4 ] )
  test.identical( got, [ [ 1, [ 3, 4 ] ], [ 2, [ 3, 4 ] ] ] );
  test.is( got !== src );

  test.close( 'array' );

  /* - */

  test.open( 'Set' );

  test.case = 'single argument';

  var src = new Set( [ 1 ] );
  var got = routine( src );
  test.identical( [ ... got ], [ [ 1 ] ] );
  test.is( got !== src );

  var src = new Set( [ 1, 2, 3 ] );
  var got = routine( src );
  test.identical( [ ... got ], [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = new Set( [ 1, 2, 3 ] );
  var got = routine( src, 2 );
  test.identical( [ ... got ], [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = new Set( [ 2 ] );
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( [ ... got ], [ [ 2, [ 1, 2, 3 ] ] ] );
  test.is( got !== src );

  var src = new Set( [ 1, 2 ] );
  var got = routine( new Set( [ 1, 2 ] ), [ 3, 4 ] )
  test.identical( [ ... got ], [ [ 1, [ 3, 4 ] ], [ 2, [ 3, 4 ] ] ] );
  test.is( got !== src );

  test.close( 'Set' );

  /* - */

  var src = _.containerAdapter.make( [ 1, 2 ] );
  var got = routine( src, [ 3, 4 ] )
  test.identical( [ ... got[ 0 ].original ], [ 1, 2 ] );
  test.identical( [ got[ 1 ] ], [ [ 3, 4 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) );
  var got = routine( src, 2 );
  test.identical( [ ... got[ 0 ].original ], [ 1, 2, 3 ] );
  test.identical( [ got[ 1 ] ], [ 2 ] );
  test.is( got !== src );

  /* - */

  test.open( 'containerAdapter, no unwraping' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 1,
    vectorizingContainerAdapter : 1,
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'single argument';
  var src = _.containerAdapter.make( [ 1 ] );
  var got = routine( src );
  test.identical( got.original, [ [ 1 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 1, 2, 3 ] );
  var got = routine( src );
  test.identical( got.original, [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = _.containerAdapter.make( [ 1, 2, 3 ] );
  var got = routine( src, 2 );
  test.identical( got.original, [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 2 ] );
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( got.original, [ [ 2, [ 1, 2, 3 ] ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 1, 2 ] );
  var got = routine( src, [ 3, 4 ] )
  test.identical( got.original, [ [ 1, [ 3, 4 ] ], [ 2, [ 3, 4 ] ] ] );
  test.is( got !== src );

  /* */

  var src = _.containerAdapter.make( new Set( [ 1 ] ) );
  var got = routine( src );
  test.identical( [ ... got.original ], [ [ 1 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) );
  var got = routine( src );
  test.identical( [ ... got.original ], [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) );
  var got = routine( src, 2 );
  test.identical( [ ... got.original ], [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 2 ] );
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( [ ... got.original ], [ [ 2, [ 1, 2, 3 ] ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( new Set( [ 1, 2 ] ) );
  var got = routine( src, [ 3, 4 ] )
  test.identical( [ ... got.original ], [ [ 1, [ 3, 4 ] ], [ 2, [ 3, 4 ] ] ] );
  test.is( got !== src );

  test.close( 'containerAdapter, no unwraping' );

  /* - */

  test.open( 'containerAdapter, no unwraping' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 1,
    vectorizingContainerAdapter : 1,
    unwrapingContainerAdapter : 1,
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'single argument';

  var src = _.containerAdapter.make( [ 1 ] );
  var got = routine( src );
  test.identical( got, [ [ 1 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 1, 2, 3 ] );
  var got = routine( _.containerAdapter.make( [ 1, 2, 3 ] ) );
  test.identical( got, [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = _.containerAdapter.make( [ 1, 2, 3 ] );
  var got = routine( _.containerAdapter.make( [ 1, 2, 3 ] ), 2 );
  test.identical( got, [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 2 ] );
  var got = routine( _.containerAdapter.make( [ 2 ] ), [ 1, 2, 3 ] );
  test.identical( got, [ [ 2, [ 1, 2, 3 ] ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( [ 1, 2 ] );
  var got = routine( _.containerAdapter.make( [ 1, 2 ] ), [ 3, 4 ] )
  test.identical( got, [ [ 1, [ 3, 4 ] ], [ 2, [ 3, 4 ] ] ] );
  test.is( got !== src );

  /* */

  var src = _.containerAdapter.make( new Set( [ 1 ] ) );
  var got = routine( src );
  test.identical( [ ... got ], [ [ 1 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) );
  var got = routine( _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) ) );
  test.identical( [ ... got ], [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) );
  var got = routine( _.containerAdapter.make( new Set( [ 1, 2, 3 ] ) ), 2 );
  test.identical( [ ... got ], [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( new Set( [ 2 ] ) );
  var got = routine( _.containerAdapter.make( new Set( [ 2 ] ) ), [ 1, 2, 3 ] );
  test.identical( [ ... got ], [ [ 2, [ 1, 2, 3 ] ] ] );
  test.is( got !== src );

  var src = _.containerAdapter.make( new Set( [ 1, 2 ] ) );
  var got = routine( _.containerAdapter.make( new Set( [ 1, 2 ] ) ), [ 3, 4 ] )
  test.identical( [ ... got ], [ [ 1, [ 3, 4 ] ], [ 2, [ 3, 4 ] ] ] );
  test.is( got !== src );

  test.close( 'containerAdapter, no unwraping' );

  /* - */

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 1,
    bypassingEmpty : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'without arguments';
  var got = routine();
  test.identical( got, [] );
}

//

function vectorizeOriginalRoutine( test )
{
  var srcRoutine = function()
  {
    return _.longSlice( arguments );
  }

  /* */

  var o =
  {
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    select : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );
  test.identical( routine, srcRoutine );

  test.case = 'empty';
  var got = routine();
  test.identical( got, [] );

  test.case = 'arguments';
  var got = routine( [ 1, 2 ], [ 3, 4 ] );
  test.identical( got, [ [ 1, 2 ], [ 3, 4 ] ] );
}

//

function vectorizeVectorizeMapOrArray( test )
{
  var srcRoutine = function()
  {
    if( arguments.length === 0 )
    return null;
    return _.longSlice( arguments );
  }

  /* - */

  test.open( 'vectorizingArray : 0, vectorizingMapVals : 1, select : 1' );

  var o =
  {
    vectorizingArray : 0,
    vectorizingMapVals : 1,
    select : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  /* */

  test.case = 'without arguments';
  var got = routine();
  test.identical( got, null );

  test.case = 'single argument';

  var src = 1;
  var got = routine( src );
  test.identical( got, [ 1 ] );
  test.is( got !== src );

  var src = [ 1 ];
  var got = routine( src );
  test.identical( got, [ [ 1 ] ] );
  test.is( got !== src );

  var src = [ 1, 2, 3 ];
  var got = routine( src );
  test.identical( got, [ [ 1, 2, 3 ] ] );
  test.is( got !== src );

  var src = { 1 : 1, 2 : 2, 3 : 3 };
  var got = routine( src );
  test.identical( got, { 1 : [ 1 ] , 2 : [ 2 ], 3 : [ 3 ] } );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = 1;
  var got = routine( src, 0 );
  test.identical( got, [ 1, 0 ] );
  test.is( got !== src );

  var src = [ 1, 2, 3 ];
  var got = routine( src, 2 );
  test.identical( got, [ [ 1, 2, 3 ], 2 ] );
  test.is( got !== src );

  var src = 2;
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( got, [ 2, [ 1, 2, 3 ] ] );
  test.is( got !== src );

  var src = [ 1, 2 ];
  var got = routine( src, [ 1, 2 ] );
  test.identical( got, [ [ 1,2 ], [ 1,2 ] ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 0 );
  test.identical( got, { a : [ 1, 0 ] } );
  test.is( got !== src );

  var src = 0;
  var got = routine( src, { a : 1 } );
  test.identical( routine( 0, { a : 1 } ), [ 0, { a : 1 } ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { b : 2 } );
  test.identical( got, { a : [ 1, { b : 2 } ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 2, 3 );
  test.identical( got, { a : [ 1, 2, 3 ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { b : 2 }, { c : 3 } );
  test.identical( got, { a : [ 1, { b : 2 }, { c : 3 } ] } );
  test.is( got !== src );

  /* */

  test.case = 'not an array, not a map';
  var src = _.containerAdapter.make( [ 1 ] );
  var got = routine( src );
  test.identical( got[ 0 ].original, [ 1 ] );
  test.identical( got.length, 1 );
  test.is( got !== src );

  test.close( 'vectorizingArray : 0, vectorizingMapVals : 1, select : 1' );

  /* - */

  test.open( 'vectorizingArray : 0, vectorizingMapVals : 1, select : 2' );

  var o =
  {
    vectorizingArray : 0,
    vectorizingMapVals : 1,
    select : 2
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'multiple argument';

  var src = 1;
  var got = routine( src, 0 );
  test.identical( got, [ 1, 0 ] );
  test.is( got !== src );

  var src = [ 1, 2, 3 ];
  var got = routine( src, 2 );
  test.identical( got, [ [ 1, 2, 3 ], 2 ] );
  test.is( got !== src );

  var src = 2;
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( got, [ 2, [ 1, 2, 3 ] ] );
  test.is( got !== src );

  var src = [ 1, 2 ];
  var got = routine( src, [ 1, 2 ] );
  test.identical( got, [ [ 1,2 ], [ 1,2 ] ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 0 );
  test.identical( got, { a : [ 1, 0 ] } );
  test.is( got !== src );

  var src = 0;
  var got = routine( src, { a : 1 } );
  test.identical( routine( 0, { a : 1 } ), { a : [ 0, 1 ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { a : 2 } );
  test.identical( got, { a : [ 1, 2 ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 2 );
  test.identical( got, { a : [ 1, 2 ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { a : [ 2 ] } );
  test.identical( got, { a : [ 1, [ 2 ] ] } );
  test.is( got !== src );

  /* */

  test.case = 'not an array, not a map';
  var src = _.containerAdapter.make( [ 1 ] );
  var got = routine( src, 1 );
  test.identical( got[ 0 ].original, [ 1 ] );
  test.identical( got.length, 2 );
  test.is( got !== src );

  /* */

  if( Config.debug )
  {
    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => routine() );

    test.case = 'one argument';
    test.shouldThrowErrorSync( () => routine( 1 ) );
    test.shouldThrowErrorSync( () => routine( [ 1, 2, 3 ] ) );
    test.shouldThrowErrorSync( () => routine( { a : 1, b : 2 } ) );

    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () => routine( [ 1 ], 2, 3 ) );

    test.case = 'different keys';
    test.shouldThrowErrorSync( () => routine( { a : 1 }, { b : 2 } ) );
  }

  test.close( 'vectorizingArray : 0, vectorizingMapVals : 1, select : 2' );

  /* - */

  test.open( 'vectorizingArray : 1, vectorizingMapVals : 1, select : 1' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    select : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'single argument';

  var src = 1;
  var got = routine( src );
  test.identical( got, [ 1 ] );
  test.is( got !== src );

  var src = [ 1 ];
  var got = routine( src );
  test.identical( got, [ [ 1 ] ] );
  test.is( got !== src );

  var src = [ 1, 2, 3 ];
  var got = routine( src );
  test.identical( got, [ [ 1 ], [ 2 ], [ 3 ] ] );
  test.is( got !== src );

  var src = { 1 : 1, 2 : 2, 3 : 3 };
  var got = routine( src );
  test.identical( got, { 1 : [ 1 ] , 2 : [ 2 ], 3 : [ 3 ] } );
  test.is( got !== src );

  test.case = 'multiple argument';

  var src = 1;
  var got = routine( src, 0 );
  test.identical( got, [ 1, 0 ] );
  test.is( got !== src );

  var src = [ 1, 2, 3 ];
  var got = routine( src, 2 );
  test.identical( got, [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ] ] );
  test.is( got !== src );

  var src = 2;
  var got = routine( src, [ 1, 2, 3 ] );
  test.identical( got, [ 2, [ 1, 2, 3 ] ] );
  test.is( got !== src );

  var src = [ 1, 2 ];
  var got = routine( src, [ 1, 2 ] );
  test.identical( got, [ [ 1, [ 1, 2 ] ], [ 2, [ 1, 2 ] ] ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 0 );
  test.identical( got, { a : [ 1, 0 ] } );
  test.is( got !== src );

  var src = 0;
  var got = routine( src, { a : 1 } );
  test.identical( got, [ 0, { a : 1 } ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { b : 2 } );
  test.identical( got, { a : [ 1, { b : 2 } ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 2, 3 );
  test.identical( got, { a : [ 1, 2, 3 ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { b : 2 }, { c : 3 } );
  test.identical( got, { a : [ 1, { b : 2 }, { c : 3 } ] } );
  test.is( got !== src );

  var src = [ 1 ];
  var got = routine( src, { a : 2 } );
  test.identical( got, [ [ 1, { a : 2 } ] ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, [ 2 ] );
  test.identical( got, { a : [ 1, [ 2 ] ] } );
  test.is( got !== src );

  var src = [ 1 ];
  var got = routine( src, { a : 2 }, 3 );
  test.identical( got, [ [ 1, { a : 2 }, 3 ] ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, [ 2 ], 3 );
  test.identical( got, { a : [ 1, [ 2 ], 3 ] } );
  test.is( got !== src );

  test.close( 'vectorizingArray : 1, vectorizingMapVals : 1, select : 1' );

  /* */

  test.open( 'vectorizingArray : 1, vectorizingMapVals : 1, select : 2' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    select : 2
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  var src = [ 1, 2 ];
  var got = routine( src, 3 );
  test.identical( got, [ [ 1, 3 ], [ 2, 3 ] ] );
  test.is( got !== src );

  var src = 1;
  var got = routine( src, [ 1, 2 ] );
  test.identical( got, [ [ 1, 1 ], [ 1, 2 ] ] );
  test.is( got !== src );

  var src = [ 1, 2 ];
  var got = routine( src, [ 1, 2 ] );
  test.identical( got, [ [ 1, 1 ], [ 2, 2 ] ] );
  test.is( got !== src );

  var src = 1;
  var got = routine( src, 2 );
  test.identical( got, [ 1, 2 ] );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, 1 );
  test.identical( got, { a : [ 1, 1 ] } );
  test.is( got !== src );

  var src = 1;
  var got = routine( src, { a : 1 } );
  test.identical( got, { a : [ 1, 1 ] } );
  test.is( got !== src );

  var src = { a : 1 };
  var got = routine( src, { a : 2 } );
  test.identical( got, { a : [ 1, 2 ] } );
  test.is( got !== src );

  var src = { a : 1, b : 1 };
  var got = routine( src, { b : 2, a : 2 } );
  test.identical( got, { a : [ 1,2 ], b : [ 1,2 ] } );
  test.is( got !== src );

  test.close( 'vectorizingArray : 1, vectorizingMapVals : 1, select : 2' );

  var o =
  {
    vectorizingArray : 0,
    vectorizingMapVals : 1,
    select : 1,
    bypassingEmpty : 1,
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  /* */

  test.case = 'without arguments';
  var got = routine();
  test.identical( got, [] );
}

//

function vectorizeVectorizeForOptionsMap( test )
{
  var srcRoutine = function()
  {
    return _.longSlice( arguments );
  }

  /* - */

  test.open( 'without pre' );

  test.open( 'array' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 'b'
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'not map, not set, not array';
  var src = '1';
  var got = routine( src );
  test.identical( got, [ '1' ] );
  test.is( got !== src );

  test.case = 'single argument';

  var src = [ 1 ];
  var got = routine( src );
  test.identical( got, [ [ 1 ] ] );
  test.is( got !== src );

  var src = { a : 0 };
  var got = routine( src );
  test.identical( got, [ { a : 0 } ] );
  test.is( got !== src );

  var src = { a : 0, b : 1 };
  var got = routine( src );
  test.identical( got, [ { a : 0, b : 1 } ] );
  test.is( got !== src );

  var src = { a : 0, b : [ 1 ] };
  var got = routine( src );
  test.identical( got, [ [ { a : 0, b : 1 } ] ] );
  test.is( got !== src );

  var src = { a : 0, b : [ 1, 2 ] };
  var got = routine( src );
  test.identical( got, [ [ { a : 0, b : 1 } ], [ { a : 0, b : 2 } ] ] );
  test.is( got !== src );

  /* */

  if( Config.debug )
  {
    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => routine() );

    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () => routine( { a : 0, b : [ 1 ] }, 2 ) );
  }

  test.close( 'array' );

  /* - */

  test.open( 'Set' );

  test.case = 'single argument';

  var src = new Set( [ 1 ] );
  var got = routine( src );
  test.identical( [ ... got[ 0 ] ], [ 1 ] );
  test.identical( got.length, 1 );
  test.is( got !== src );

  var src = { b : new Set( [ 0 ] ) };
  var got = routine( src );
  test.identical( [ ... got ], [ [ { b : 0 } ] ] );
  test.is( got !== src );

  var src = { b : new Set( [ 0 ] ), a : 1 };
  var got = routine( src );
  test.identical( [ ... got ], [ [ { b : 0, a : 1 } ] ] );
  test.is( got !== src );

  var src = { b : new Set( [ [ 0 ] ] ), a : 1 };
  var got = routine( src );
  test.identical( [ ... got ], [ [ { b : [ 0 ], a : 1 } ] ] );
  test.is( got !== src );

  var src = { b : new Set( [ 1, 2 ] ),  a : 0 };
  var got = routine( src );
  test.identical( [ ... got ], [ [ { a : 0, b : 1 } ], [ { a : 0, b : 2 } ] ] );
  test.is( got !== src );

  test.close( 'Set' );

  test.close( 'without pre' );

  /* - */

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 'b',
    bypassingEmpty : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'without arguments';
  var got = routine();
  test.identical( got, [] );
}

//

function vectorizeVectorizeForOptionsMapForKeys( test )
{
  var srcRoutine = function()
  {
    if( arguments.length === 0 )
    return null;
    return _.longSlice( arguments );
  }

  //

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : [ 'a', 'b' ]
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.case = 'single argument';

  var src = 'a';
  var got = routine( src );
  var expected = [ [ src ], [ src ] ];
  test.identical( got, expected );

  var src = [ 1 ]
  var got = routine( src );
  var expected = [ [ src ], [ src ] ];
  test.identical( got, expected );

  var src = { c : 1 }
  var got = routine( src );
  var expected = [ [ src ], [ src ] ];
  test.identical( got, expected );

  var got = routine({ a : 0, b : [ 1 ] });
  var expected =
  [
    [
      {
        a : 0,
        b : [ 1 ]
      }
    ],
    [
      [
        { a : 0, b : 1 }
      ]
    ]
  ]
  test.identical( got, expected );

  /**/

  var got = routine({ a : 0, b : [ 1,2 ] });
  var expected =
  [
    [
      {
        a : 0,
        b : [ 1,2 ]
      }
    ],
    [
      [
        { a : 0, b : 1 }
      ],
      [
        { a : 0, b : 2 }
      ]
    ],

  ]
  test.identical( got, expected );

  test.case = 'multiple argument';

  if( Config.debug )
  test.shouldThrowErrorSync( () => routine({ a : 0, b : [ 1 ] }, 2 ) );
}

//

function vectorize( test )
{
  function srcRoutine( a,b )
  {
    return _.longSlice( arguments );
  }

  //

  test.open( 'vectorizingArray : 1,select : 2' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    select : 2
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.identical( routine( [ 1,2 ], 1 ), [ [ 1,1 ], [ 2,1 ] ] );
  test.identical( routine( 1, [ 1,2 ] ), [ [ 1,1 ], [ 1,2 ] ] );
  test.identical( routine( [ 1,2 ], [ 1,2 ] ), [ [ 1,1 ], [ 2,2 ] ] );
  test.identical( routine( 1,2 ), [ 1,2 ] );

  test.identical( routine( { a : 1 }, 1 ), [ { a : 1 }, 1 ] );
  test.identical( routine( 1, { a : 1 } ), [ 1, { a : 1 }] );
  test.identical( routine( { a : 1 }, { b : 2 } ), [ { a : 1 }, { b : 2 } ] );

  test.identical( routine( [ 1 ], { a : 2 } ), [ [ 1, { a : 2 } ] ] );
  test.identical( routine( [ 1,2 ], { a : 3 } ), [ [ 1, { a : 3 } ], [ 2, { a : 3 } ] ] );
  test.identical( routine( { a : 3 }, [ 1,2 ] ), [ [ { a : 3 }, 1  ], [ { a : 3 }, 2 ] ] );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => routine( 1 ) );
    test.shouldThrowErrorSync( () => routine( 1,2,3 ) );
    test.shouldThrowErrorSync( () => routine( [ 1,2 ], [ 1,2,3 ] ) );
    test.shouldThrowErrorSync( () => routine( [ 1 ], [ 2 ], [ 3 ] ) );
  }

  test.close( 'vectorizingArray : 1,select : 2' );

  //

  test.open( 'vectorizingArray : 1, vectorizingMapVals : 1,select : 2' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    select : 2
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.identical( routine( [ 1,2 ], 3 ), [ [ 1,3 ], [ 2,3 ] ] );
  test.identical( routine( 1, [ 1,2 ] ), [ [ 1,1 ], [ 1,2 ] ] );
  test.identical( routine( [ 1,2 ], [ 1,2 ] ), [ [ 1,1 ], [ 2,2 ] ] );
  test.identical( routine( 1,2 ), [ 1,2 ] );

  test.identical( routine( { a : 1 }, 1 ), { a : [ 1, 1 ] } );
  test.identical( routine( 1, { a : 1 } ), { a : [ 1, 1 ] } );
  test.identical( routine( { a : 1 }, { a : 2 } ), { a : [ 1,2 ] } );
  test.identical( routine( { a : 1, b : 1 }, { b : 2, a : 2 } ), { a : [ 1,2 ], b : [ 1,2 ] } );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => routine( [ 1,2 ], [ 1,2,3 ] ) )
    test.shouldThrowErrorSync( () => routine( 1,2,3 ) );
    test.shouldThrowErrorSync( () => routine( { a : 1 }, { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( [ 1 ], { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( { b : 1 }, [ 1 ] ) );
    test.shouldThrowErrorSync( () => routine( 1, [ 1 ], { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( [ 1 ], 1, { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( { b : 1 }, 1, [ 1 ] ) );
    test.shouldThrowErrorSync( () => routine( { b : 1 }, [ 1 ], 1 ) );
  }

  test.close( 'vectorizingArray : 1, vectorizingMapVals : 1,select : 2' );

  test.open( ' vectorizingMapKeys : 1' );

  var o =
  {
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 1
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.identical( routine( 1  ), [ 1 ] );
  test.identical( routine( [ 1 ] ), [ [ 1 ] ] );
  test.identical( routine( { a : 1 } ), { a : 1 } );

  if( Config.debug )
  test.shouldThrowErrorSync( () => routine( 1, 2 ) )

  test.close( ' vectorizingMapKeys : 1' );

  test.open( 'vectorizingMapKeys : 1, select : 2' );

  var o =
  {
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 2
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.identical( routine(  1, 1  ), [ 1, 1 ] );
  test.identical( routine( [ 1 ], 1 ), [ [ 1 ], 1 ] );
  test.identical( routine( { a : 1 }, 'b' ), { 'a,b' : 1 } );
  test.identical( routine( 'a', { b : 1, c : 2 } ), { 'a,b' : 1, 'a,c' : 2 } );
  test.identical( routine( [ 'a' ], { b : 1, c : 2 } ), { 'a,b' : 1, 'a,c' : 2 } );
  test.identical( routine( { b : 1, c : 2 }, [ 'a' ] ), { 'b,a' : 1, 'c,a' : 2 } );

  if( Config.debug )
  test.shouldThrowErrorSync( () => routine( 1,2,3 ) );

  test.close( 'vectorizingMapKeys : 1, select : 2' );

  test.open( 'vectorizingMapKeys : 1, vectorizingArray : 1, select : 2' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 2
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.identical( routine( [ 1,2 ], 3 ), [ [ 1,3 ], [ 2,3 ] ] );
  test.identical( routine( 1, [ 1,2 ] ), [ [ 1,1 ], [ 1,2 ] ] );
  test.identical( routine( [ 1,2 ], [ 1,2 ] ), [ [ 1,1 ], [ 2,2 ] ] );
  test.identical( routine( 1,2 ), [ 1,2 ] );

  test.identical( routine( { a : 1 }, 'b' ), { 'a,b' : 1 } );
  test.identical( routine( 'a', { b : 1, c : 2 } ), { 'a,b' : 1, 'a,c' : 2 } );

  test.identical( routine( { a : 1 }, 1 ), { 'a,1' : 1 } );
  test.identical( routine( 1, { b : 1, c : 2 } ), { '1,b' : 1, '1,c' : 2 } );

  test.identical( routine( [ 1 ], { b : true } ), { '1,b' : true } );
  test.identical( routine( [ 1,2 ], { b : true } ), { '1,b' : true, '2,b' : true } );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => routine( 1,2,3 ) );
    test.shouldThrowErrorSync( () => routine( { a : 1 }, { b : 1 } ) );
    // test.shouldThrowErrorSync( () => routine( [ 1 ], { b : 1 } ) );
    // test.shouldThrowErrorSync( () => routine( { b : 1 }, [ 1 ] ) );
    // test.shouldThrowErrorSync( () => routine( 1, [ 1 ], { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( [ 1 ], 1, { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( { b : 1 }, 1, [ 1 ] ) );
    test.shouldThrowErrorSync( () => routine( { b : 1 }, [ 1 ], 1 ) );
  }

  test.close( 'vectorizingMapKeys : 1, vectorizingArray : 1, select : 2' );

  test.open( 'vectorizingMapKeys : 1, vectorizingArray : 1, select : 3' );

  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 3
  }
  o.routine = srcRoutine;
  var routine = _.vectorize( o );

  test.identical( routine( [ 1 ], { b : true }, 'c' ), { '1,b,c' : true } );
  test.identical( routine( [ 1 ], { b : true }, [ 'c' ] ), { '1,b,c' : true } );
  test.identical( routine( [ 1 ], { b : true, c : false }, 'd' ), { '1,b,d' : true, '1,c,d' : false } );
  test.identical( routine( [ 1,2 ], { b : true }, 'c' ), { '1,b,c' : true, '2,b,c' : true } );

  //

  var got =  routine( [ 1,2 ], { b : true, c : false }, [ 'd', 'e' ] );
  var expected =
  {
    '1,b,d' : true,
    '1,c,d' : false,
    '2,b,e' : true,
    '2,c,e' : false
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], [ 'd', 'e' ], { b : true, c : false } );
  var expected =
  {
    '1,d,b' : true,
    '1,d,c' : false,
    '2,e,b' : true,
    '2,e,c' : false
  }
  test.identical( got, expected );

  //

  var got =  routine( { b : true, c : false }, [ 1,2 ], [ 'd', 'e' ]  );
  var expected =
  {
    'b,1,d' : true,
    'c,1,d' : false,
    'b,2,e' : true,
    'c,2,e' : false
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], { b : true, c : false, d : true }, [ 'e', 'f' ] );
  var expected =
  {
    '1,b,e' : true,
    '1,c,e' : false,
    '1,d,e' : true,
    '2,b,f' : true,
    '2,c,f' : false,
    '2,d,f' : true
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], [ 'e', 'f' ], { b : true, c : false, d : true } );
  var expected =
  {
    '1,e,b' : true,
    '1,e,c' : false,
    '1,e,d' : true,
    '2,f,b' : true,
    '2,f,c' : false,
    '2,f,d' : true
  }
  test.identical( got, expected );

  //

  var got =  routine( { b : true, c : false, d : true }, [ 1,2 ], [ 'e', 'f' ] );
  var expected =
  {
    'b,1,e' : true,
    'c,1,e' : false,
    'd,1,e' : true,
    'b,2,f' : true,
    'c,2,f' : false,
    'd,2,f' : true
  }
  test.identical( got, expected );

  //

  var got =  routine( 1, { b : true, c : false, d : true }, 2 );
  var expected =
  {
    '1,b,2' : true,
    '1,c,2' : false,
    '1,d,2' : true
  }
  test.identical( got, expected );

  //

  var got =  routine( { b : true, c : false, d : true }, 1, 2 );
  var expected =
  {
    'b,1,2' : true,
    'c,1,2' : false,
    'd,1,2' : true
  }
  test.identical( got, expected );

  //

  var got =  routine( 1, 2, { b : true, c : false, d : true } );
  var expected =
  {
    '1,2,b' : true,
    '1,2,c' : false,
    '1,2,d' : true
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], { b : true }, 'c' );
  var expected =
  {
    '1,b,c' : true,
    '2,b,c' : true,
  }
  test.identical( got, expected );

  //

  var got =  routine( { b : true }, [ 1,2 ], 'c' );
  var expected =
  {
    'b,1,c' : true,
    'b,2,c' : true,
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], 'c', { b : true } );
  var expected =
  {
    '1,c,b' : true,
    '2,c,b' : true,
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], { b : true, c : false }, 'd' );
  var expected =
  {
    '1,b,d' : true,
    '1,c,d' : false,
    '2,b,d' : true,
    '2,c,d' : false
  }
  test.identical( got, expected );

  //

  var got =  routine( { b : true, c : false }, [ 1,2 ], 'd' );
  var expected =
  {
    'b,1,d' : true,
    'b,2,d' : true,
    'c,1,d' : false,
    'c,2,d' : false
  }
  test.identical( got, expected );

  //

  var got =  routine( [ 1,2 ], 'd', { b : true, c : false } );
  var expected =
  {
    '1,d,b' : true,
    '1,d,c' : false,
    '2,d,b' : true,
    '2,d,c' : false
  }
  test.identical( got, expected );

  //

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => routine( { a : 1 }, 'c', { b : 1 } ) );
    test.shouldThrowErrorSync( () => routine( [ 1 ], { b : true }, [ 'c', 'd' ] ) );
  }

  test.close( 'vectorizingMapKeys : 1, vectorizingArray : 1, select : 3' );

  test.open( 'vectorizingMapKeys : 1, vectorizingArray : 1, vectorizingMapVals : 1, select : 1' );
  function srcRoutine2( src )
  {
    return src + 1;
  }
  var o =
  {
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 1,
    select : 1
  }
  o.routine = srcRoutine2;
  var routine = _.vectorize( o );

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 2 , 21 : 3, 31 : 4 } );

  test.close( 'vectorizingMapKeys : 1, vectorizingArray : 1, vectorizingMapVals : 1, select : 1' );
}

//

function vectorizeBypassingEmpty( test )
{
  function srcRoutine()
  {
    _.sure( arguments.length );
    return _.longSlice( arguments );
  }

  function srcRoutine2()
  {
    _.sure( arguments.length );
    return arguments[ 0 ] + 1;
  }

  //

  test.open( 'vectorizing off, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine,
    bypassingEmpty : 0,
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.case = 'with arg';
  var got = routine( 1 );
  var expected = [ 1 ];
  test.identical( got, expected )

  test.close( 'vectorizing off, bypassingEmpty:0' );

  //

  test.open( 'vectorizing off, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine,
    bypassingEmpty : 1,
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.case = 'with arg';
  var got = routine( 1 );
  var expected = [ 1 ];
  test.identical( got, expected )

  test.close( 'vectorizing off, bypassingEmpty:0' );

  //

  test.open( 'vectorizingArray:1, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine,
    bypassingEmpty : 0,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.case = 'with arg';
  var got = routine( 1 );
  var expected = [ 1 ];
  test.identical( got, expected )

  test.close( 'vectorizingArray:1, bypassingEmpty:0' );

  //

  test.open( 'vectorizingArray:1, bypassingEmpty:1' );

  var routine = _.vectorize
  ({
    routine : srcRoutine,
    bypassingEmpty : 1,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  var got = routine();
  var expected = [];
  test.identical( got, expected )

  test.case = 'with arg';
  var got = routine( 1 );
  var expected = [ 1 ];
  test.identical( got, expected )

  test.close( 'vectorizingArray:1, bypassingEmpty:1' );

  //

  test.open( 'vectorizingMapVals:1, bypassingEmpty:1' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 1,
    vectorizingArray : 0,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  var got = routine();
  var expected = [];
  test.identical( got, expected )

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), '11' );
  test.identical( routine( [ 1,2,3 ] ), '1,2,31' );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 1 : 2 , 2 : 3, 3 : 4 } );

  test.close( 'vectorizingMapVals:1, bypassingEmpty:1' );

  //

  test.open( 'vectorizingMapVals:1, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 0,
    vectorizingArray : 0,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), '11' );
  test.identical( routine( [ 1,2,3 ] ), '1,2,31' );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 1 : 2 , 2 : 3, 3 : 4 } );

  test.close( 'vectorizingMapVals:1, bypassingEmpty:0' );

  //

  test.open( 'vectorizingArray:1, vectorizingMapVals:1, bypassingEmpty:1' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 1,
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  var got = routine();
  var expected = [];
  test.identical( got, expected )

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 1 : 2 , 2 : 3, 3 : 4 } );

  test.close( 'vectorizingArray:1, vectorizingMapVals:1, bypassingEmpty:1' );

  //

  test.open( 'vectorizingArray:1, vectorizingMapVals:1, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 0,
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 0,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 1 : 2 , 2 : 3, 3 : 4 } );

  test.close( 'vectorizingArray:1, vectorizingMapVals:1, bypassingEmpty:0' );

  //

  test.open( 'vectorizingMapKeys:1, bypassingEmpty:1' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 1,
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 1
  });

  test.case = 'no arg';
  var got = routine();
  var expected = [];
  test.identical( got, expected )

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), '11' );
  test.identical( routine( [ 1,2,3 ] ), '1,2,31' );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 1 , 21 : 2, 31 : 3 } );

  test.close( 'vectorizingMapKeys:1, bypassingEmpty:1' );

  //

  test.open( 'vectorizingMapKeys:1, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 0,
    vectorizingArray : 0,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), '11' );
  test.identical( routine( [ 1,2,3 ] ), '1,2,31' );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 1 , 21 : 2, 31 : 3 } );

  test.close( 'vectorizingMapKeys:1, bypassingEmpty:0' );

  //

  test.open( 'vectorizingArray:1, vectorizingMapKeys:1, bypassingEmpty:1' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 1,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 1
  });

  test.case = 'no arg';
  var got = routine();
  var expected = [];
  test.identical( got, expected )

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 1 , 21 : 2, 31 : 3 } );

  test.close( 'vectorizingArray:1, vectorizingMapKeys:1, bypassingEmpty:1' );

  //

  test.open( 'vectorizingArray:1, vectorizingMapKeys:1, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 0,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 1,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 1 , 21 : 2, 31 : 3 } );

  test.close( 'vectorizingArray:1, vectorizingMapKeys:1, bypassingEmpty:0' );

  //

  test.open( 'vectorizingArray:1, vectorizingMapKeys:1, vectorizingMapVals : 1, bypassingEmpty:1' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 1,
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 1,
    select : 1
  });

  test.case = 'no arg';
  var got = routine();
  var expected = [];
  test.identical( got, expected )

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 2 , 21 : 3, 31 : 4 } );

  test.close( 'vectorizingArray:1, vectorizingMapKeys:1, vectorizingMapVals : 1, bypassingEmpty:1' );

  //

  test.open( 'vectorizingArray:1, vectorizingMapKeys:1, vectorizingMapVals : 1, bypassingEmpty:0' );

  var routine = _.vectorize
  ({
    routine : srcRoutine2,
    bypassingEmpty : 0,
    vectorizingArray : 1,
    vectorizingMapVals : 1,
    vectorizingMapKeys : 1,
    select : 1
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.identical( routine( 1 ), 2 );
  test.identical( routine( [ 1 ] ), [ 2 ] );
  test.identical( routine( [ 1,2,3 ] ), [ 2,3,4 ] );
  test.identical( routine( { 1 : 1, 2 : 2, 3 : 3 } ), { 11 : 2 , 21 : 3, 31 : 4 } );

  test.close( 'vectorizingArray:1, vectorizingMapKeys:1, vectorizingMapVals : 1, bypassingEmpty:0' );

  // vectorizeForOptionsMapForKeys

  test.open( 'vectorizingArray:1, select : array, bypassingEmpty:0' );

  function srcRoutine3( src )
  {
    return src;
  }

  var routine = _.vectorize
  ({
    routine : srcRoutine3,
    bypassingEmpty : 0,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 0,
    select : [ '0' ]
  });

  test.case = 'no arg';
  test.shouldThrowErrorSync( () => routine() );

  test.identical( routine( 1 ), [ 1 ] );
  test.identical( routine( [ 1 ] ), [ [ 1 ] ] );
  test.identical( routine( [ [ 1 ] ] ), [ [ { 0 : 1 } ] ] );
  test.identical( routine( { 0 : [ 1 ] } ), [ [ { 0 : 1 } ] ] );

  test.close( 'vectorizingArray:1, select : array, bypassingEmpty:0' );

  //

  test.open( 'vectorizingArray:1, select : array, bypassingEmpty:1' );

  function srcRoutine3( src )
  {
    return src;
  }

  var routine = _.vectorize
  ({
    routine : srcRoutine3,
    bypassingEmpty : 1,
    vectorizingArray : 1,
    vectorizingMapVals : 0,
    vectorizingMapKeys : 0,
    select : [ '0' ]
  });

  test.identical( routine(), [] );
  test.identical( routine( 1 ), [ 1 ] );
  test.identical( routine( [ 1 ] ), [ [ 1 ] ] );
  test.identical( routine( [ [ 1 ] ] ), [ [ { 0 : 1 } ] ] );
  test.identical( routine( { 0 : [ 1 ] } ), [ [ { 0 : 1 } ] ] );

  test.close( 'vectorizingArray:1, select : array, bypassingEmpty:1' );
}

//

function vectorizeAll( test )
{

  test.case = 'trivial';
  function isOdd( a )
  {
    return a % 2;
  }
  isOdd.map1 = {};
  isOdd.map1.a = 1;
  isOdd.map2 = Object.create( {} );
  isOdd.map2.a = 2;
  isOdd.str = 'str';
  isOdd.number = 13;
  isOdd.routine = function r(){};
  var got = _.vectorizeAll( isOdd );
  test.equivalent( got.map1, isOdd.map1 );
  test.equivalent( got.map2, isOdd.map2 );
  test.equivalent( got.str, isOdd.str );
  test.equivalent( got.number, isOdd.number );
  test.equivalent( got.routine, isOdd.routine );
  test.is( _.routineIs( got ) );
  test.identical( got([ 0, 1, 2, 3 ]), 0 );
  test.identical( got([ 0, 2 ]), 0 );
  test.identical( got([ 1, 3 ]), true );

}

//

function vectorizeAny( test )
{

  test.case = 'trivial';
  function isOdd( a )
  {
    return a % 2;
  }
  isOdd.map1 = {};
  isOdd.map1.a = 1;
  isOdd.map2 = Object.create( {} );
  isOdd.map2.a = 2;
  isOdd.str = 'str';
  isOdd.number = 13;
  isOdd.routine = function r(){};
  var got = _.vectorizeAny( isOdd );
  test.equivalent( got.map1, isOdd.map1 );
  test.equivalent( got.map2, isOdd.map2 );
  test.equivalent( got.str, isOdd.str );
  test.equivalent( got.number, isOdd.number );
  test.equivalent( got.routine, isOdd.routine );
  test.is( _.routineIs( got ) );
  test.identical( got([ 0, 1, 2, 3 ]), 1 );
  test.identical( got([ 0, 2 ]), false );
  test.identical( got([ 1, 3 ]), 1 );

}

//

function vectorizeNone( test )
{

  test.case = 'trivial';
  function isOdd( a )
  {
    return a % 2;
  }
  isOdd.map1 = {};
  isOdd.map1.a = 1;
  isOdd.map2 = Object.create( {} );
  isOdd.map2.a = 2;
  isOdd.str = 'str';
  isOdd.number = 13;
  isOdd.routine = function r(){};
  var got = _.vectorizeNone( isOdd );
  test.equivalent( got.map1, isOdd.map1 );
  test.equivalent( got.map2, isOdd.map2 );
  test.equivalent( got.str, isOdd.str );
  test.equivalent( got.number, isOdd.number );
  test.equivalent( got.routine, isOdd.routine );
  test.is( _.routineIs( got ) );
  test.identical( got([ 0, 1, 2, 3 ]), false );
  test.identical( got([ 0, 2 ]), true );
  test.identical( got([ 1, 3 ]), false );

}

//

function vectorizeAccess( test )
{
  test.open( 'get' );

  test.case = 'get property, not a routine';
  var vector = [ { a : 1, b : 2 }, { a : 3, b : 4, c : 5 } ];
  var src = _.vectorizeAccess( vector );
  var got = src.a;
  test.identical( got[ '$' ], [ 1, 3 ] );

  test.case = 'execute method on number';
  var routine = ( e ) => e;
  var vector = [ { a : routine, b : 2 }, { a : routine, b : 4, c : 5 } ];
  var src = _.vectorizeAccess( vector );
  var got = src.a( 1 );
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'execute method on element of vector';
  var routine = ( e ) => e;
  var vector = [ { a : routine, b : 2 }, { a : routine, b : 4, c : 5 } ];
  var src = _.vectorizeAccess( vector );
  var got = src.a( vector[ 0 ] );
  test.identical( got[ '$' ], [ { a : routine, b : 2 }, { a : routine, b : 2 } ] );
  test.is( got !== src );

  test.case = 'execute method on element of vector, execute new vector';
  var routine = ( e ) => e;
  var vector = [ { a : routine, b : 2 }, { a : routine, b : 4, c : 5 } ];
  var src = _.vectorizeAccess( vector );
  var got = src.a( vector[ 0 ] ).a( 1 );
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'passed element of vector, return original proxy';
  var routine = ( e ) => e;
  var vector = [ { a : routine, b : 2 } ];
  var src = _.vectorizeAccess( vector );
  var got = src.a( vector[ 0 ] );
  test.identical( got[ '$' ], [ { a : routine, b : 2 } ] );
  test.is( got === src );

  /* - */

  test.case = 'vector has not nested vectors or objects, key is $';
  var vector = [ 1, 2, 3, 4 ];
  var src = _.vectorizeAccess( vector );
  var got = src[ '$' ];
  test.identical( got, [ 1, 2, 3, 4 ] );
  test.is( got === vector );

  test.case = 'get first element of vectors, not a routine';
  var vector = [ [ 1, 2 ], [ 1, 2 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ];
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'execute routine in vectors on number';
  var routine = ( e ) => e;
  var vector = [ [ routine, 2 ], [ routine, 3 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( 1 );
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'execute routine in vectors on element of original vector';
  var routine = ( e ) => e;
  var vector = [ [ routine, 2 ], [ routine, 3 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( vector[ 0 ] );
  test.identical( got[ '$' ], [ [ routine, 2 ], [ routine, 2 ] ] );
  test.is( got !== src );

  test.case = 'execute routine in vectors on element of original vector, execute resulted vector on number';
  var routine = ( e ) => e;
  var vector = [ [ routine, 2 ], [ routine, 3 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( vector[ 0 ] )[ 0 ]( 1 );
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'passed element of vector ';
  var routine = ( e ) => e;
  var vector = [ [ routine, 2 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( vector[ 0 ] );
  test.identical( got[ '$' ], [ [ routine, 2 ] ] );
  test.is( got === src );

  /* - */

  test.case = 'get first element of vectors, not a routine';
  var vector = [ { 0 : 1, 1 : 2 }, [ 1, 2 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ];
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'execute routine in vectors on number';
  var routine = ( e ) => e;
  var vector = [ { 0 : routine, 1 : 2 }, [ routine, 3 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( 1 );
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.case = 'execute routine in vectors on element of original vector';
  var routine = ( e ) => e;
  var vector = [ { 0 : routine, 1 : 2 }, [ routine, 3 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( vector[ 0 ] );
  test.identical( got[ '$' ], [ { 0 : routine, 1 : 2 }, { 0 : routine, 1 : 2 } ] );
  test.is( got !== src );

  test.case = 'execute routine on element of original vector, execute resulted vector on number';
  var routine = ( e ) => e;
  var vector = [ { 0 : routine, 1 : 2 }, [ routine, 3 ] ];
  var src = _.vectorizeAccess( vector );
  var got = src[ 0 ]( vector[ 0 ] )[ 0 ]( 1 );
  test.identical( got[ '$' ], [ 1, 1 ] );

  test.close( 'get' );

  /* - */

  test.open( 'set' );

  test.case = 'set property of objects';
  var vector = [ { a : 1, b : 2 }, { a : 3, b : 4, c : 1 }, { a : 5, b : 6 } ];
  var src = _.vectorizeAccess( vector );
  test.identical( src[ '$' ], [ { a : 1, b : 2 }, { a : 3, b : 4, c : 1 }, { a : 5, b : 6 } ] );
  src.a = 0;
  test.identical( src[ '$' ], [ { a : 0, b : 2 }, { a : 0, b : 4, c : 1 }, { a : 0, b : 6 } ] );

  test.case = 'set method in property of objects';
  var routine = ( e ) => e;
  var vector = [ { a : 1, b : 2 }, { a : 3, b : 4, c : 1 }, { a : 5, b : 6 } ];
  var src = _.vectorizeAccess( vector );
  test.identical( src[ '$' ], [ { a : 1, b : 2 }, { a : 3, b : 4, c : 1 }, { a : 5, b : 6 } ] );
  src.b = routine;
  test.identical( src[ '$' ], [ { a : 1, b : routine }, { a : 3, b : routine, c : 1 }, { a : 5, b : routine } ] );

  /* */

  test.case = 'set property of vectors';
  var vector = [ [ 1, 2 ], [ 3, 4, 1 ], [ 5, 6 ] ];
  var src = _.vectorizeAccess( vector );
  test.identical( src[ '$' ], [ [ 1, 2 ], [ 3, 4, 1 ], [ 5, 6 ] ] );
  src[ 0 ] = 0;
  test.identical( src[ '$' ], [ [ 0, 2 ], [ 0, 4, 1 ], [ 0, 6 ] ] );

  test.case = 'set method in property of objects';
  var routine = ( e ) => e;
  var vector = [ [ 1, 2 ], [ 3, 4, 1 ], [ 5, 6 ] ];
  var src = _.vectorizeAccess( vector );
  test.identical( src[ '$' ], [ [ 1, 2 ], [ 3, 4, 1 ], [ 5, 6 ] ] );
  src[ 1 ] = routine;
  test.identical( src[ '$' ], [ [ 1, routine ], [ 3, routine, 1 ], [ 5, routine ] ] );

  /* */

  test.case = 'set property of vectors';
  var vector = [ { 0 : 1, 1 : 2 }, [ 3, 4, 1 ], [ 5, 6 ] ];
  var src = _.vectorizeAccess( vector );
  test.identical( src[ '$' ], [ { 0 : 1, 1 : 2 }, [ 3, 4, 1 ], [ 5, 6 ] ] );
  src[ 0 ] = 0;
  test.identical( src[ '$' ], [ { 0 : 0, 1 : 2 }, [ 0, 4, 1 ], [ 0, 6 ] ] );

  test.case = 'set method in property of objects';
  var routine = ( e ) => e;
  var vector = [ { 0 : 1, 1 : 2 }, [ 3, 4, 1 ], [ 5, 6 ] ];
  var src = _.vectorizeAccess( vector );
  test.identical( src[ '$' ], [ { 0 : 1, 1 : 2 }, [ 3, 4, 1 ], [ 5, 6 ] ] );
  src[ 1 ] = routine;
  test.identical( src[ '$' ], [ { 0 : 1, 1 : routine }, [ 3, routine, 1 ], [ 5, routine ] ] );

  test.close( 'set' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.vectorizeAccess() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.vectorizeAccess( [ { name : 'a', id : '20' } ], [ { date : '01.01.2020' } ] ) );

  test.case = 'object has no property, get property';
  test.shouldThrowErrorSync( () =>
  {
    var src = _.vectorizeAccess( [ { a : 1 }, { b : 1 } ] );
    var got = src.a;
  } );

  test.case = 'object has no property, set property';
  test.shouldThrowErrorSync( () =>
  {
    var src = _.vectorizeAccess( [ { a : 1 }, { b : 1 } ] );
    src.a = 2;
  } );
}

// --
//
// --

var Self =
{

  name : 'ModuleForTesting1.base.Routine',
  silencing : 1,

  tests :
  {

    routineIs,
    routineLike,
    routineIsSync,
    routineIsAsync,
    routineIsPure,

    /* qqq : tests for constructorJoin, extend tests for routineJoin | Dmytro : coverage is extended */

    _routineJoin,
    constructorJoin,
    routineJoin,
    routineSeal,

    routinesCompose,
    routinesComposeAll,
    routinesComposeAllReturningLast,
    routinesChain,

    routineExtend,
    routineDefaults,

    vectorizeVectorizeArray,
    vectorizeOriginalRoutine,
    vectorizeVectorizeMapOrArray,
    vectorizeVectorizeForOptionsMap,
    vectorize,
    /* qqq : split test routine vectorize */
    /* qqq : add tests for vectorize* routines */
    vectorizeBypassingEmpty,

    vectorizeAll, /* qqq : extend please */
    vectorizeAny, /* qqq : extend please */
    vectorizeNone, /* qqq : extend please */

    vectorizeAccess,

  }

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
