( function _Consequence_s_() {

'use strict';

/**
 * Advanced synchronization mechanism. Asynchronous routines may use Consequence to wrap postponed result, what allows classify callback for such routines as output, not input, what improves analyzability of a program. Consequence may be used to make a queue for mutually exclusive access to a resource. Algorithmically speaking Consequence is 2 queues ( FIFO ) and a customizable arbitrating algorithm. The first queue contains available resources, the second queue includes competitors for this resources. At any specific moment, one or another queue may be empty or full. Arbitrating algorithm makes resource available for a competitor as soon as possible. There are 2 kinds of resource: regular and erroneous. Unlike Promise, Consequence is much more customizable and can solve engineering problem which Promise cant. But have in mind with great power great responsibility comes. Consequence can coexist and interact with a Promise, getting fulfillment/rejection of a Promise or fulfilling it. Use Consequence to get more flexibility and improve readability of asynchronous aspect of your application.
  @module Tools/base/Consequence
*/

/**
 * @file Consequence.s.
 */

/*

= Concepts

Consequence ::
Resource ::
Error of resource ::
Argument of resource ::
Competitor ::
Procedure ::

*/

/*

= Principles

1. Methods of Consequence should call callback instantly and synchronously if all necessary data provided, otherwise, Consequence should call callback asynchronously.
2. Handlers of keeping methods cannot return undefined. It is often a sign of a bug.
3. A resource of Consequence cannot have both an error and an argument but must have either one.

*/

/*

= Groups

1. then / except / finally
2. give / keep

*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );
  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wProcedure' );

}

let _global = _global_;
let _ = _global_.wTools;
let Deasync = null;

if( _realGlobal_.wTools && _realGlobal_.wConsequence )
{
  _.assert( _.routineIs( _realGlobal_.wConsequence.After ) );
  let Tools =
  {
    after : _realGlobal_.wConsequence.After,
    // before : _realGlobal_.wTools.before,
  }
  _.mapExtend( _, Tools );
  let Self = _realGlobal_.wConsequence;
  _[ Self.shortName ] = Self;
  if( typeof module !== 'undefined' && module !== null )
  module[ 'exports' ] = Self;
  return;
}

_.assert( !_global_.wConsequence, 'Consequence included several times' );
_.assert( !_.Consequence, 'Consequence included several times' );

// relations

let KindOfResource =
{
  ErrorOnly : 1,
  ArgumentOnly : 2,
  Both : 3,
  BothWithCompetitor : 4,
}

//

/**

 */

/**
 * Function that accepts result of wConsequence value computation. Used as parameter in methods such as finallyGive(), finally(),
  etc.
 * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
    value no exception occurred, it will be set to null;
   @param {*} value resolved by wConsequence value;
 * @callback Competitor
 * @memberof module:Tools/base/Consequence.wConsequence~
 */

/**
 * Creates instance of wConsequence
 * @classdesc Class wConsequence creates objects that used for asynchronous computations. It represent the queue of results that
 * can computation asynchronously, and has a wide range of tools to implement this process.
 * @param {Object|Function|wConsequence} [o] initialization options
 * @example
   let con = new _.Consequence();
   con.take( 'hello' ).finallyGive( function( err, value) { console.log( value ); } ); // hello

   let con = _.Consequence();
   con.finallyGive( function( err, value) { console.log( value ); } ).take('world'); // world
 * @class wConsequence
 * @memberof module:Tools/base/Consequence
 * @returns {wConsequence}
 */

/* heavy optimization */

class wConsequence extends _.CallableObject
{
  constructor()
  {
    let self = super();
    Self.prototype.init.apply( self, arguments );
    return self;
  }
}

let wConsequenceProxy = new Proxy( wConsequence,
{
  apply : function apply( original, context, args )
  {
    let o = args[ 0 ];

    if( o )
    if( o instanceof Self )
    {
      o = _.mapOnly( o, Self.Composes );
    }

    if( Config.debug )
    {
      if( o === undefined )
      {
        o = Object.create( null );
        args[ 0 ] = o;
      }
      if( o.sourcePath === undefined || o.sourcePath === null )
      o.sourcePath = 1;
      if( _.numberIs( o.sourcePath ) )
      o.sourcePath = o.sourcePath += 1;
      o.sourcePath = _.procedure.sourcePathGet( o.sourcePath );
    }
    return new original( ...args );
  },

  set : function set( original, name, value )
  {
    debugger;
    return Reflect.set( ...arguments );
  },

});

let Parent = null;
let Self = wConsequenceProxy;

wConsequence.shortName = 'Consequence';

// --
// inter
// --

/**
 * Initialises instance of wConsequence
 * @param {Object|wConsequence} [o] initialization options
 * @private
 * @method init
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function init( o )
{
  let self = this;

  // if( o )
  // if( o.tag === 'openedReady' )
  // debugger;

  // self._competitorsEarly = [];
  // self._competitorsLate = [];
  // self._resources = [];
  // self._procedure = null;
  // self.capacity = self.Composes.capacity;

  if( Config.debug )
  {
    // self.tag = self.Composes.tag;
    // self.id = _.procedure.indexAlloc();
    // self._dependsOf = [];
    // self.sourcePath = null;
  }

  // Object.preventExtensions( self );

  if( o )
  {
    if( !Config.debug )
    {
      delete o.tag;
      delete o.capacity;
      delete o.sourcePath;
    }
    if( o instanceof Self )
    {
      o = _.mapOnly( o, self.Composes );
    }
    else
    {
      _.assertMapHasOnly( o, self.Composes );
    }
    if( o._resources )
    o._resources = o._resources.slice();
    // if( o._competitorsEarly )
    // o._competitorsEarly = o._competitorsEarly.slice();
    // if( o._competitorsLate )
    // o._competitorsLate = o._competitorsLate.slice();
    _.mapExtend( self, o );
    // self.copy( o );
  }

  if( Config.debug )
  {
    if( self.sourcePath === undefined || self.sourcePath === null )
    self.sourcePath = 1;
    if( _.numberIs( self.sourcePath ) )
    self.sourcePath = self.sourcePath += 2;
    self.sourcePath = _.procedure.sourcePathGet( self.sourcePath );
  }

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.sourcePath === undefined || _.strIs( self.sourcePath ) );
}

//

function is( src )
{
  _.assert( arguments.length === 1 );
  return _.consequenceIs( src );
}

//

function isJoinedWithConsequence( src )
{
  _.assert( arguments.length === 1 );
  debugger;
  let result = _.isSubPrototypeOf( src, JoinedWithConsequence );
  if( result )
  debugger;
  return result;
}

// --
// basic
// --

/**
 * Method appends resolved value and error competitor to wConsequence competitors sequence. That competitor accept only one
    value or error reason only once, and don't pass result of it computation to next competitor (unlike Promise 'finally').
    if finallyGive() called without argument, an empty competitor will be appended.
    After invocation, competitor will be removed from competitors queue.
    Returns current wConsequence instance.
 * @example
     function gotHandler1( error, value )
     {
       console.log( 'competitor 1: ' + value );
     };

     function gotHandler2( error, value )
     {
       console.log( 'competitor 2: ' + value );
     };

     let con1 = new _.Consequence();

     con1.finallyGive( gotHandler1 );
     con1.take( 'hello' ).take( 'world' );

     // prints only " competitor 1: hello ",

     let con2 = new _.Consequence();

     con2.finallyGive( gotHandler1 ).finallyGive( gotHandler2 );
     con2.take( 'foo' );

     // prints only " competitor 1: foo "

     let con3 = new _.Consequence();

     con3.finallyGive( gotHandler1 ).finallyGive( gotHandler2 );
     con3.take( 'bar' ).take( 'baz' );

     // prints
     // competitor 1: bar
     // competitor 2: baz
     //
 * @param {module:Tools/base/Consequence.wConsequence~Competitor|wConsequence} [competitor] callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @see {@link module:Tools/base/Consequence.wConsequence~Competitor} competitor callback
 * @throws {Error} if passed more than one argument.
 * @method finallyGive
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function finallyGive( competitorRoutine )
{
  let self = this;
  let times = 1;

  _.assert( arguments.length === 1, 'Expects none or single argument, but got', arguments.length, 'arguments' );

  if( _.numberIs( competitorRoutine ) )
  {
    times = competitorRoutine;
    competitorRoutine = function(){};
  }

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : false,
    kindOfResource : Self.KindOfResource.Both,
    times,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );

  return self;
}

finallyGive.having =
{
  consequizing : 1,
}

//

function finallyKeep( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.Both,
    stackLevel : 2,
    times : 1,
  });

  self.__handleResourceSoon( false );

  return self;
}

finallyKeep.having =
{
  consequizing : 1,
}

//

function thenGive( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : false,
    kindOfResource : Self.KindOfResource.ArgumentOnly,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );

  return self;
}

thenGive.having =
{
  consequizing : 1,
}

//

/**
 * Method pushed `competitor` callback into wConsequence competitors queue. That callback will
   trigger only in that case if accepted error parameter will be null. Else accepted error will be passed to the next
   competitor in queue. After handling accepted value, competitor pass result to the next competitor, like finally
   method.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finally method
 * @method thenKeep
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function thenKeep( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.ArgumentOnly,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

thenKeep.having =
{
  consequizing : 1,
}

//

function catchGive( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : false,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );
  return self;
}

catchGive.having =
{
  consequizing : 1,
}

//

/**
 * catchKeep method pushed `competitor` callback into wConsequence competitors queue. That callback will
   trigger only in that case if accepted error parameter will be defined and not null. Else accepted parameters will
   be passed to the next competitor in queue.

 * @param {module:Tools/base/Consequence.wConsequence~Competitor|wConsequence} competitor callback, that accepts exception  reason and value .
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finally method
 * @method catchKeep
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function catchKeep( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stackLevel : 2,
    // early : true,
  });

  self.__handleResourceSoon( false );

  return self;
}

catchKeep.having =
{
  consequizing : 1,
}

// --
// promise
// --

function _promise( o )
{
  let self = this;
  let keeping = o.keeping;
  let kindOfResource =  o.kindOfResource;
  let procedure = self.procedure( 'promise' ).sourcePathFirst( 3 );
  self.procedureDetach();

  _.assertRoutineOptions( _promise, arguments );

  let result = new Promise( function( resolve, reject )
  {
    self.procedure( procedure );

    self._competitorAppend
    ({
      keeping : 0,
      competitorRoutine,
      // kindOfResource : o.kindOfResource,
      kindOfResource : self.KindOfResource.Both,
      stackLevel : 3,
    });

    self.__handleResourceSoon( false );

    function competitorRoutine( err, arg )
    {
      if( err )
      {
        if( kindOfResource === self.KindOfResource.Both || kindOfResource === self.KindOfResource.ErrorOnly )
        reject( err );
      }
      else
      {
        if( kindOfResource === self.KindOfResource.Both || kindOfResource === self.KindOfResource.ErrorOnly )
        resolve( arg );
      }
      if( keeping )
      self.take( err, arg );
    };

  });

  return result;
}

_promise.defaults =
{
  keeping : null,
  kindOfResource : null,
}

_promise.having =
{
  consequizing : 1,
}

//

function finallyPromiseGive()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._promise
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.Both,
  });
}

finallyPromiseGive.having = Object.create( _promise.having );

//

/**
 * Method accepts competitor for resolved value/error. This competitor method finally adds to wConsequence competitors sequence.
    After processing accepted value, competitor return value will be pass to the next competitor in competitors queue.
    Returns current wConsequence instance.

 * @example
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   };

   function gotHandler3( error, value )
   {
     console.log( 'competitor 3: ' + value );
   };

   let con1 = new _.Consequence();

   con1.finally( gotHandler1 ).finally( gotHandler1 ).finallyGive(gotHandler3);
   con1.take( 4 ).take( 10 );

   // prints:
   // competitor 1: 4
   // competitor 1: 5
   // competitor 3: 6

 * @param {module:Tools/base/Consequence.wConsequence~Competitor|wConsequence} competitor callback, that accepts resolved value or exception reason.
 * @returns {wConsequence}
 * @throws {Error} if missed competitor.
 * @throws {Error} if passed more than one argument.
 * @see {@link module:Tools/base/Consequence.wConsequence~Competitor} competitor callback
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finallyGive method
 * @method finally
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function finallyPromiseKeep()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._promise
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.Both,
  });
}

finallyPromiseKeep.having = Object.create( _promise.having );

//

function thenPromiseGive()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._promise
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.ArgumentOnly,
  });
}

thenPromiseGive.having = Object.create( _promise.having );

//

function thenPromiseKeep()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._promise
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.ArgumentOnly,
  });
}

thenPromiseKeep.having = Object.create( _promise.having );

//

function exceptPromiseGive()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._promise
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.ErrorOnly,
  });
}

exceptPromiseGive.having = Object.create( _promise.having );

//

function exceptPromiseKeep()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._promise
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.ErrorOnly,
  });
}

exceptPromiseKeep.having = Object.create( _promise.having );

// --
// deasync
// --

function _deasync( o )
{
  let self = this;
  let procedure = self.procedure( '_deasync' ).sourcePathFirst( 3 );
  let keeping = o.keeping;
  let result = Object.create( null );
  let ready = false;

  _.assertRoutineOptions( _deasync, arguments );

  self._competitorAppend
  ({
    competitorRoutine,
    kindOfResource : self.KindOfResource.Both,
    keeping : 0,
    stackLevel : 3,
  });

  self.__handleResourceSoon( false );

  if( Deasync === null )
  Deasync = require( 'deasync' );
  Deasync.loopWhile( () => !ready )

  if( result.err )
  if( self.KindOfResource.Both || self.KindOfResource.ErrorOnly )
  throw result.err;
  else
  return new _.Consequence().error( result.err );

  if( self.KindOfResource.Both || self.KindOfResource.ArgumentOnly )
  return result.arg;
  else
  return new _.Consequence().take( result.arg );

  function competitorRoutine( err, arg )
  {
    result.err = err;
    result.arg = arg;
    ready = true;
    if( keeping )
    self.take( err, arg );
  };

}

_deasync.defaults =
{
  keeping : null,
  kindOfResource : null,
}

_deasync.having =
{
  consequizing : 1,
}

//

function finallyDeasyncGive()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._deasync
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.Both,
  });
}

finallyDeasyncGive.having = Object.create( _deasync.having );

//

function finallyDeasyncKeep()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._deasync
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.Both,
  });
}

finallyDeasyncGive.having = Object.create( _deasync.having );

//

function thenDeasyncGive()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._deasync
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.ArgumentOnly,
  });
}

finallyDeasyncGive.having = Object.create( _deasync.having );

//

function thenDeasyncKeep()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._deasync
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.ArgumentOnly,
  });
}

finallyDeasyncGive.having = Object.create( _deasync.having );

//

function exceptDeasyncGive()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._deasync
  ({
    keeping : 0,
    kindOfResource : self.KindOfResource.ErrorOnly,
  });
}

finallyDeasyncGive.having = Object.create( _deasync.having );

//

function exceptDeasyncKeep()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._deasync
  ({
    keeping : 1,
    kindOfResource : self.KindOfResource.ErrorOnly,
  });
}

finallyDeasyncGive.having = Object.create( _deasync.having );

// --
// advanced
// --

function _first( src, stack )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.consequenceIs( src ) )
  {
    src.finally( self );
  }
  else if( _.routineIs( src ) )
  {
    let result;

    try
    {
      result = src();
      _.assert( result !== undefined, 'Competitor for consequence.first should return something, not undefined' );
    }
    catch( err )
    {
      // result = new _.Consequence().error( err );
      result = new _.Consequence().error( self.__handleError( err ) );
    }

    if( _.consequenceIs( result ) )
    result.finally( self );
    else
    self.take( result );

  }
  else _.assert( 0, 'first expects consequence of routine, but got', _.strType( src ) );

  return self;
}

//

/**
 * If type of `src` is function, the first method run it on begin, if the result of `src` invocation is instance of
   wConsequence, the current wConsequence will be wait for it resolving, else method added result to resources sequence
   of the current instance.
 * If `src` is instance of wConsequence, the current wConsequence delegates to it his first corespondent.
 * Returns current wConsequence instance.
 * @example
 * function handleGot1(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con = new  _.Consequence();

   con.first( function()
   {
     return 'foo';
   });

 con.take( 100 );
 con.finallyGive( handleGot1 );
 // prints: handleGot1 value: foo
*
  function handleGot1(err, val)
  {
    if( err )
    {
      console.log( 'handleGot1 error: ' + err );
    }
    else
    {
      console.log( 'handleGot1 value: ' + val );
    }
  };

  let con = new  _.Consequence();

  con.first( function()
  {
    return _.Consequence().take(3);
  });

 con.take(100);
 con.finallyGive( handleGot1 );
 * @param {wConsequence|Function} src wConsequence or routine.
 * @returns {wConsequence}
 * @throws {Error} if `src` has unexpected type.
 * @method first
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function first( src )
{
  let self = this;
  return self._first( src, null );
}

first.having =
{
  consequizing : 1,
}

//

/**
 * Returns new _.Consequence instance. If on cloning moment current wConsequence has unhandled resolved values in queue
   the first of them would be handled by new _.Consequence. Else pass accepted
 * @example
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   };

   function gotHandler2( error, value )
   {
     console.log( 'competitor 2: ' + value );
   };

   let con1 = new _.Consequence();
   con1.take(1).take(2).take(3);
   let con2 = con1.split();
   con2.finallyGive( gotHandler2 );
   con2.finallyGive( gotHandler2 );
   con1.finallyGive( gotHandler1 );
   con1.finallyGive( gotHandler1 );

    // prints:
    // competitor 2: 1 // only first value copied into cloned wConsequence
    // competitor 1: 1
    // competitor 1: 2

 * @returns {wConsequence}
 * @throws {Error} if passed any argument.
 * @method splitKeep
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function splitKeep( first )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = new Self({ sourcePath : 2 });

  if( first ) // xxx : remove, maybe argument?
  {
    result.finally( first );
    self.give( function( err, arg )
    {
      result.take( err, arg );
      this.take( err, arg );
    });
  }
  else
  {
    self.finally( result );
  }

  return result;
}

splitKeep.having =
{
  consequizing : 1,
}

//

function splitGive( first )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = new Self({ sourcePath : 2 });

  if( first ) // xxx : remove, maybe argument?
  {
    result.finally( first );
    self.give( function( err, arg )
    {
      result.take( err, arg );
    });
  }
  else
  {
    self.finallyGive( result );
  }

  return result;
}

splitGive.having =
{
  consequizing : 1,
}

//

/**
 * Works like finallyGive() method, but value that accepts competitor, passes to the next taker in takers queue without
   modification.
 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   }

   function gotHandler2( error, value )
   {
     console.log( 'competitor 2: ' + value );
   }

   function gotHandler3( error, value )
   {
     console.log( 'competitor 3: ' + value );
   }

   let con1 = new _.Consequence();
   con1.take(1).take(4);

   // prints:
   // competitor 1: 1
   // competitor 2: 1
   // competitor 3: 4

 * @param {module:Tools/base/Consequence.wConsequence~Competitor|wConsequence} competitor callback, that accepts resolved value or exception
   reason.
 * @returns {wConsequence}
 * @throws {Error} if passed more than one arguments
 * @see {@link module:Tools/base/Consequence.wConsequence#finallyGive} finallyGive method
 * @method tap
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function tap( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : false,
    tapping : true,
    kindOfResource : Self.KindOfResource.Both,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );

  return self;
}

tap.having =
{
  consequizing : 1,
}

/**
 * Creates and adds to corespondents sequence error competitor. If handled resource contains error, corespondent logs it.
 * @returns {wConsequence}
 * @throws {Error} If called with any argument.
 * @method exceptLog
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function exceptLog()
{
  let self = this;

  _.assert( arguments.length === 0 );

  self._competitorAppend
  ({
    competitorRoutine : reportError,
    keeping : true,
    kindOfResource : Self.KindOfResource.ErrorOnly,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );

  return self;

  /* - */

  function reportError( err )
  {
    err = _.err( err );
    logger.log( _.errOnce( err ) );
    throw err;
    // throw _.errLogOnce( err );
  }

}

exceptLog.having =
{
  consequizing : 1,
}

//

function syncMaybe()
{
  let self = this;

  if( self._resources.length === 1 )
  {
    let resource = self._resources[ 0 ];
    if( resource.error !== undefined )
    {
      // debugger;
      _.assert( resource.argument === undefined );
      throw _.err( resource.error );
    }
    else
    {
      _.assert( resource.error === undefined );
      return resource.argument;
    }
  }

  return self;
}

//

function sync()
{
  let self = this;

  _.assert( self._resources.length <= 1, () => 'Cant return resource of consequence because it has ' + self._resources.length + ' of such!' );
  _.assert( self._resources.length >= 1, () => 'Cant return resource of consequence because it has none of such!' );

  return self.syncMaybe();
}

// --
// experimental
// --

function _competitorFinally( competitorRoutine )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._competitorAppend
  ({
    competitorRoutine,
    keeping : true,
    kindOfResource : Self.KindOfResource.BothWithCompetitor,
    stackLevel : 2,
  });

  self.__handleResourceSoon( false );

  return self;
}

//

function wait()
{
  let self = this;
  let result = new _.Consequence();

  _.assert( arguments.length === 0 );

  self.finallyGive( function __wait( err, arg )
  {
    if( err )
    self.error( err );
    else
    self.take( result );
  });

  self.take( null );

  return result;
}

//

function participateGive( con )
{
  let self = this;

  _.assert( _.consequenceIs( con ) );
  _.assert( arguments.length === 1 );

  debugger;

  con.finallyGive( 1 );
  self.finallyGive( con );
  // con.take( self );

  return con;
}

//

function participateKeep( con )
{
  let self = this;

  _.assert( _.consequenceIs( con ) );
  _.assert( arguments.length === 1 );

  con.finallyGive( 1 );
  self.finallyKeep( con );

  return con;
}

// --
// put
// --

function _put( o )
{
  let self = this;
  let key = o.key;
  let container = o.container;
  let keeping = o.keeping;

  _.assert( !_.primitiveIs( o.container ), 'Expects one or two argument, container for resource or key and container' );
  _.assert( o.key === null || _.numberIs( o.key ) || _.strIs( o.key ), () => 'Key should be number or string, but it is ' + _.strType( o.key ) );

  if( o.key !== null )
  {
    self._competitorAppend
    ({
      keeping,
      kindOfResource : o.kindOfResource,
      competitorRoutine : __onPutWithKey,
      stackLevel : 3,
    });

    self.__handleResourceSoon( false );
    return self;
  }
  else if( _.arrayIs( o.container ) )
  {
    debugger;
    self._competitorAppend
    ({
      keeping,
      kindOfResource : o.kindOfResource,
      competitorRoutine : __onPutToArray,
      stackLevel : 3,
    });
    self.__handleResourceSoon( false );
    return self;
  }
  else
  {
    _.assert( 0, 'Expects key for to put to objects or fixed-size long' );
  }

  /* */

  function __onPutWithKey( err, arg )
  {
    if( err !== undefined )
    container[ key ] = err;
    else
    container[ key ] = arg;
    if( !keeping )
    return;
    if( err )
    throw err;
    return arg;
  }

  /* */

  function __onPutToArray( err, arg )
  {
    debugger;
    _.assert( 0, 'not tested' );
    if( err !== undefined )
    container.push( err );
    else
    container.push( arg );
    if( !keeping )
    return;
    if( err )
    throw err;
    return arg;
  }

}

_put.defaults =
{
  key : null,
  container :  null,
  kindOfResource : null,
  keeping  : null,
}

//

function put_pre( routine, args )
{
  let self = this;
  let o = Object.create( null );

  if( args[ 1 ] === undefined )
  {
    o = { container : args[ 0 ] }
  }
  else
  {
    o = { container : args[ 0 ], key : args[ 1 ] }
  }

  _.assert( args.length === 1 || args.length === 2, 'Expects one or two argument, container for resource or key and container' );
  _.routineOptions( routine, o );

  return o;
}

//

let putGive = _.routineFromPreAndBody( put_pre, _put, 'putGive' );
var defaults = putGive.defaults;
defaults.kindOfResource = KindOfResource.Both;
defaults.keeping = false;

let putKeep = _.routineFromPreAndBody( put_pre, _put, 'putKeep' );
var defaults = putKeep.defaults;
defaults.kindOfResource = KindOfResource.Both;
defaults.keeping = true;

let thenPutGive = _.routineFromPreAndBody( put_pre, _put, 'thenPutGive' );
var defaults = thenPutGive.defaults;
defaults.kindOfResource = KindOfResource.ArgumentOnly;
defaults.keeping = false;

let thenPutKeep = _.routineFromPreAndBody( put_pre, _put, 'thenPutKeep' );
var defaults = thenPutKeep.defaults;
defaults.kindOfResource = KindOfResource.ArgumentOnly;
defaults.keeping = true;

// --
// time
// --

function timeOut_pre( routine, args )
{
  let o = { time : args[ 0 ], competitorRoutine : args[ 1 ] };
  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( _.numberIs( o.time ) );
  return o;
}

//

function _timeOut( o )
{
  let self = this;
  let time = o.time;
  let competitorRoutine = o.competitorRoutine;

  _.assert( arguments.length === 1 );

  /* */

  if( !competitorRoutine )
  if( o.kindOfResource === Self.KindOfResource.Both )
  competitorRoutine = Self.FinallyPass;
  else if( o.kindOfResource === Self.KindOfResource.ArgumentOnly )
  competitorRoutine = Self.ThenPass;
  else if( o.kindOfResource === Self.KindOfResource.ErrorOnly )
  competitorRoutine = Self.ExceptPass;

  _.assert( _.routineIs( competitorRoutine ) );

  /* */

  let competitor0;
  if( _.consequenceIs( competitorRoutine ) )
  competitor0 = function __timeOutThen()
  {
    debugger;
    return _.timeOut( o.time, function onTimeOut( err, arg )
    {
      debugger;
      competitorRoutine.take.apply( competitorRoutine, arguments );
      if( err )
      throw _.err( err );
      return arg;
    });
  }
  else
  competitor0 = function __timeOutThen()
  {
    return _.timeOut( o.time, self, competitorRoutine, arguments );
  }

  /* */

  self._competitorAppend
  ({
    keeping : true,
    competitorRoutine : competitor0,
    kindOfResource : o.kindOfResource,
    stackLevel : 3,
  });

  self.__handleResourceSoon( false );

  return self;
}

_timeOut.defaults =
{
  time : null,
  competitorRoutine : null,
  kindOfResource : null,
}

_timeOut.having =
{
  consequizing : 1,
}

//

/**
 * Works like finally, but when competitor accepts resource from resources sequence, execution of competitor will be
    delayed. The result of competitor execution will be passed to the competitor that is first in competitor queue
    on execution end moment.

 * @example
 *
   function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
     value++;
     return value;
   }

   function gotHandler2( error, value )
   {
     console.log( 'competitor 2: ' + value );
   }

   let con = new _.Consequence();

   con.timeOut(500, gotHandler1).finallyGive( gotHandler2 );
   con.take(90);
   //  prints:
   // competitor 1: 90
   // competitor 2: 91

 * @param {number} time delay in milliseconds
 * @param {module:Tools/base/Consequence.wConsequence~Competitor|wConsequence} competitor callback, that accepts exception reason and value.
 * @returns {wConsequence}
 * @throws {Error} if missed arguments.
 * @throws {Error} if passed extra arguments.
 * @see {@link module:Tools/base/Consequence.wConsequence#finally} finally method
 * @method timeOut
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

let finnallyTimeOut = _.routineFromPreAndBody( timeOut_pre, _timeOut, 'finnallyTimeOut' );
var defaults = finnallyTimeOut.defaults;
defaults.kindOfResource = KindOfResource.Both;

let thenTimeOut = _.routineFromPreAndBody( timeOut_pre, _timeOut, 'thenTimeOut' );
var defaults = thenTimeOut.defaults;
defaults.kindOfResource = KindOfResource.ArgumentOnly;

let exceptTimeOut = _.routineFromPreAndBody( timeOut_pre, _timeOut, 'exceptTimeOut' );
var defaults = exceptTimeOut.defaults;
defaults.kindOfResource = KindOfResource.ErrorOnly;

// --
// and
// --

function and_pre( routine, args )
{
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { competitors : args[ 0 ] };

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  return o;
}

//

function _and( o )
{
  let self = this;
  let errs = [];
  let args = [];
  let anyErr;
  let competitors = o.competitors;
  let taking = o.taking;
  let accumulative = o.accumulative;
  let procedure = self.procedure( 'and' ).sourcePathFirst( o.stackLevel + 1 );
  let escaped = 0;

  _.assertRoutineOptions( _and, arguments );

  /* */

  if( !_.arrayIs( competitors ) )
  competitors = [ competitors ];
  else
  competitors = competitors.slice();
  competitors.push( self );
  let count = competitors.length;

  /* */

  if( Config.debug && self.Diagnostics )
  {
    let competitors2 = [];

    for( let s = 0 ; s < competitors.length-1 ; s++ )
    {
      let competitor = competitors[ s ];
      _.assert( _.consequenceIs( competitor ) || _.routineIs( competitor ) || competitor === null, () => 'Consequence.and expects consequence, routine or null, but got ' + _.strType( competitor ) );
      if( !_.consequenceIs( competitor ) )
      continue;
      if( _.arrayHas( competitors2, competitor ) )
      continue;
      competitor.assertNoDeadLockWith( self );
      _.arrayAppendOnceStrictly( self._dependsOf, competitor );
      competitors2.push( competitor );
    }

  }

  /* */

  self.finallyGive( start );

  escaped = 1;
  return self;

  /* - */

  function start( err, arg )
  {
    let competitors2 = [];

    for( let c = 0 ; c < competitors.length-1 ; c++ )
    {
      let competitor = competitors[ c ];
      let wasRoutine = false;

      if( !_.consequenceIs( competitor ) && _.routineIs( competitor ) )
      try
      {
        wasRoutine = true;
        competitor = competitors[ c ] = competitor();
      }
      catch( err )
      {
        competitor = new _.Consequence().error( _.err( err ) );
      }

      _.assert( _.consequenceIs( competitor ) || competitor === null, () => 'Expects consequence or null, but got ' + _.strType( competitor ) );

      if( competitor === null )
      {
        __got.call( c, undefined, null );
        continue;
      }
      else if( _.arrayHas( competitors2, competitor ) )
      {
        continue;
      }

      /*
      accounting of dependencies of routines
      consequences have already been accounted
      */

      competitors2.push( competitor );

      if( wasRoutine )
      if( _.consequenceIs( competitor ) )
      if( Config.debug && self.Diagnostics )
      {
        competitor.assertNoDeadLockWith( self );
        _.assert( !_.arrayHas( self._dependsOf, competitor ) );
        _.arrayAppendOnceStrictly( self._dependsOf, competitor );
      }

      let r = __got;

      competitor.procedure( 'and' ).sourcePathFirst( procedure.sourcePath() );
      competitor.finallyGive( r );

    }

    __got.call( self, err, arg );

  }

  /* */

  function __got( err, arg )
  {
    let first = -1;

    // if( err && !anyErr )
    // anyErr = _.err( err );
    // if( err )
    // debugger;
    // if( err )
    // err = _.err( err );

    if( err && !anyErr )
    anyErr = err;

    if( _.numberIs( this ) )
    account( this )
    else
    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitor = competitors[ c ];
      if( competitor === this )
      account( c );
    }

    if( Config.debug && self.Diagnostics )
    if( first < competitors.length-1 )
    if( _.consequenceIs( this ) )
    {
      _.arrayRemoveElementOnceStrictly( self._dependsOf, this );
    }

    _.assert( count >= 0 );

    if( count === 0 )
    {
      if( escaped )
      _.timeSoon( __take );
      else
      __take();
    }

    function account( c )
    {
      errs[ c ] = err;
      args[ c ] = arg;
      count -= 1;
      if( first === -1 )
      first = c;
    }

  }

  /* */

  function __take()
  {

    let competitors2 = [];
    if( !taking )
    for( let i = 0 ; i < competitors.length-1 ; i++ )
    if( competitors[ i ] )
    {
      let competitor = competitors[ i ]
      if( _.arrayHas( competitors2, competitor ) )
      continue;
      competitor.take( errs[ i ], args[ i ] );
      competitors2.push( competitor );
    }

    if( accumulative )
    args = _.arrayFlatten( args );

    if( anyErr )
    self.error( anyErr );
    else
    self.take( args );

  }

}

_and.defaults =
{
  competitors : null,
  taking : 1,
  accumulative : 0,
  stackLevel : 2,
}

var having = _and.having = Object.create( null );
having.consequizing = 1;
having.andLike = 1;

//

/**
 * Method accepts array of wConsequences object. If current wConsequence instance ready to resolve resource, it will be
   wait for all passed wConsequence instances will been resolved, finally current wConsequence resolve own resource.
   Returns current wConsequence.
 * @example
 *
   function handleGot1(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con1 = new _.Consequence();
   let con2 = new _.Consequence();

   con1.finallyGive( function( err, value )
   {
     console.log( 'con1 competitor executed with value: ' + value + 'and error: ' + err );
   } );

   con2.finallyGive( function( err, value )
   {
     console.log( 'con2 competitor executed with value: ' + value + 'and error: ' + err );
   } );

   let conOwner = new  _.Consequence();

   conOwner.andTake( [ con1, con2 ] );

   conOwner.take( 100 );
   conOwner.finallyGive( handleGot1 );

   con1.take( 'value1' );
   con2.error( 'ups' );
   // prints
   // con1 competitor executed with value: value1and error: null
   // con2 competitor executed with value: undefinedand error: ups
   // handleGot1 value: 100

 * @param {wConsequence[]|wConsequence} competitors array of wConsequence
 * @returns {wConsequence}
 * @throws {Error} if missed arguments.
 * @throws {Error} if passed extra arguments.
 * @method andTake
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

let andTake = _.routineFromPreAndBody( and_pre, _and, 'andTake' );
var defaults = andTake.defaults;
defaults.taking = true;

//

/**
 * Works like andTake() method, but unlike andTake() andKeep() take back massages to src consequences once all come.
 * @see {@link module:Tools/base/Consequence.wConsequence#andTake}
 * @param {wConsequence[]|wConsequence} competitors Array of wConsequence objects
 * @throws {Error} If missed or passed extra argument.
 * @method andKeep
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

let andKeep = _.routineFromPreAndBody( and_pre, _and, 'andKeep' );
var defaults = andKeep.defaults;
defaults.taking = false;

let andKeepAccumulative = _.routineFromPreAndBody( and_pre, _and, 'andKeepAccumulative' );
var defaults = andKeepAccumulative.defaults;
defaults.taking = false;
defaults.accumulative = true;

// --
// or
// --

function _or( o )
{
  let self = this;
  let count = 0;
  let procedure = self.procedure( 'or' ).sourcePathFirst( o.stackLevel + 1 );
  let competitors = o.competitors;
  let competitorRoutines = [];

  _.assertRoutineOptions( _or, arguments );

  if( !_.arrayIs( competitors ) )
  competitors = [ competitors ];
  else
  competitors = _.longSlice( competitors );

  for( let c = competitors.length-1 ; c >= 0 ; c-- )
  {
    let competitorRoutine = competitors[ c ];
    _.assert( _.consequenceIs( competitorRoutine ) || competitorRoutine === null );
    if( competitorRoutine === null )
    competitors.splice( c, 1 );
  }

  // logger.log( '_or', competitors.length, procedure._longName, self.tag );
  // debugger;

  /* */

  if( o.ready )
  self.finallyGive( function( err, arg )
  {

    if( err )
    self.error( err );
    else
    _take();

  });
  else
  {
    competitors.unshift( self );
    _take();
  }

  return self;

  /* - */

  function _take()
  {

    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitorRoutine = competitors[ c ];

      _.assert( _.consequenceIs( competitorRoutine ) );

      // if( competitorRoutine === null )
      // continue;

      competitorRoutines[ c ] = _.routineJoin( undefined, _orGot, [ c ] );
      competitorRoutine.procedure( 'or' ).sourcePathFirst( procedure.sourcePath() );
      competitorRoutine.finallyGive( competitorRoutines[ c ] );

      if( count )
      break;
    }

  }

  /* - */

  function _orGot( index, err, arg )
  {

    count += 1;

    // logger.log( '_orGot', index, procedure._longName, self.tag );

    _.assert( count === 1 );

    for( let c = 0 ; c < competitors.length ; c++ )
    {
      let competitorRoutine = competitors[ c ];
      if( c !== index && competitorRoutines[ c ] )
      competitors[ c ].competitorsCancel( competitorRoutines[ c ] );
    }

    if( count === 1 )
    self.take( err, arg );

    if( !o.taking )
    if( o.ready || index !== 0 )
    competitors[ index ].take( err, arg );

  }

}

_or.defaults =
{
  competitors : null,
  taking : null,
  ready : null,
  stackLevel : 2,
}

_or.having =
{
  consequizing : 1,
  orLike : 1,
}

//

function thenOrTaking( competitors )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  return self._or
  ({
    competitors,
    taking : true,
    ready : true,
    stackLevel : 2,
  });
}

thenOrTaking.having = Object.create( _or.having );

//

function thenOrKeeping( competitors )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  return self._or
  ({
    competitors,
    taking : false,
    ready : true,
    stackLevel : 2,
  });
}

thenOrKeeping.having = Object.create( _or.having );

//

function orKeepingSplit( competitors )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.arrayIs( competitors ) )
  competitors = [ competitors ];
  else
  competitors = competitors.slice();
  competitors.unshift( self );

  // debugger;
  let con = new Self({ sourcePath : 2 }).take( null );
  // debugger;

  con.procedure( 'orKeepingSplit' ).sourcePathFirst( 2 );
  con.thenOrKeeping( competitors );

  return con;
}

orKeepingSplit.having = Object.create( _or.having );

//

function orTaking( competitors )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  return self._or
  ({
    competitors,
    taking : true,
    ready : false,
    stackLevel : 2,
  });
}

orTaking.having = Object.create( _or.having );

//

function orKeeping( competitors )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  return self._or
  ({
    competitors,
    taking : false,
    ready : false,
    stackLevel : 2,
  });
}

orKeeping.having = Object.create( _or.having );

//

// function or( competitors )
// {
//   let self = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   if( !_.arrayIs( competitors ) )
//   competitors = [ competitors ];
//   else
//   competitors = competitors.slice();
//   competitors.unshift( self );
//
//   let con = new Self().take( null );
//
//   con.procedure( 'or' ).sourcePathFirst( 2 );
//   con.thenOrTaking( competitors );
//   con.finally( self );
//
//   return self;
// }
//
// or.having = Object.create( _or.having );

//

// /* xxx : deprecate */
// let JoinedWithConsequence = Object.create( null );
// JoinedWithConsequence.routineJoin = _.routineSeal;
// JoinedWithConsequence.context = null;
// JoinedWithConsequence.method = null;
// JoinedWithConsequence.consequence = null;
// JoinedWithConsequence.constructor = function JoinedWithConsequence()
// {
//   debugger;
// };
//
// //
//
// function _prepareJoinedWithConsequence()
// {
//
//   for( let r in Self.prototype ) ( function( r )
//   {
//     if( Self.prototype._Accessors[ r ] )
//     return;
//     let routine = Self.prototype[ r ];
//     if( !routine.having || !routine.having.consequizing )
//     return;
//
//     if( routine.having.andLike )
//     JoinedWithConsequence[ r ] = function()
//     {
//       let args = arguments;
//       let method = [];
//       _.assert( arguments.length === 1, 'Expects single argument' );
//       _.assert( _.longIs( args[ 0 ] ) );
//       for( let i = 0 ; i < args[ 0 ].length ; i++ )
//       {
//         method.push( this.routineJoin( this.context, this.method, [ args[ 0 ][ i ] ] ) );
//       }
//       this.consequence[ r ]( method );
//       return this;
//     }
//     else
//     JoinedWithConsequence[ r ] = function()
//     {
//       let args = arguments;
//       let method = this.routineJoin( this.context, this.method, args );
//       this.consequence[ r ]( method );
//       return this;
//     }
//
//   })( r );
//
// }

// --
// adapter
// --

// function _join( routineJoin, args )
// {
//   let self = this;
//   let result = Object.create( JoinedWithConsequence );
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( args.length === 1 || args.length === 2 );
//   _.assert( _.consequenceIs( this ) );
//
//   result.routineJoin = routineJoin;
//   result.consequence = self;
//
//   if( args[ 1 ] !== undefined )
//   {
//     result.context = args[ 0 ];
//     result.method = args[ 1 ];
//   }
//   else
//   {
//     result.method = args[ 0 ];
//   }
//
//   return result;
// }
//
// //
//
// function join( context, method )
// {
//   let self = this;
//   return self._join( _.routineJoin, arguments );
// }
//
// //
//
// function seal( context, method )
// {
//   let self = this;
//   return self._join( _.routineSeal, arguments );
// }

//

function tolerantCallback()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return function tolerantCallback( err, arg )
  {
    if( !err )
    err = undefined;
    if( arg === null || err )
    arg = undefined;
    return self( err, arg );
  }
}

// function seal( context, method )
// {
//   let self = this;
//   let result = Object.create( null );
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.consequenceIs( this ) );
//
//   result.consequence = self;
//
//   result.thenKeep = function thenKeep( _method )
//   {
//     let args = method ? arguments[ 1 ];
//     let c = _.routineSeal( context, method || _method, args );
//     self.thenKeep( c );
//     return this;
//   }
//
//   result.catchKeep = function catchKeep( _method )
//   {
//     let args = method ? arguments[ 1 ];
//     let c = _.routineSeal( context, method || _method, args );
//     self.catchKeep( c );
//     return this;
//   }
//
//   result.finally = function finally( _method )
//   {
//     let args = method ? arguments[ 1 ];
//     let c = _.routineSeal( context, method || _method, args );
//     self.finally( c );
//     return this;
//   }
//
//   result.finallyGive = function finallyGive( _method )
//   {
//     let args = method ? arguments[ 2 ];
//     let c = _.routineSeal( context, method || _method, args );
//     self.finallyGive( c );
//     return this;
//   }
//
//   return result;
// }

// --
// resource
// --

function takeLater( timeOut, error, argument )
{
  let self = this;

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( _.numberIs( timeOut ) );

  if( argument === undefined )
  {
    argument = arguments[ 1 ];
    error = undefined;
  }

  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );

  /* */

  _.timeBegin( timeOut, function now()
  {
    self.take( error, argument );
  });

  return self;
}

takeLater.having =
{
  consequizing : 1,
}

//

function takeSoon( error, argument )
{
  let self = this;

  _.assert( arguments.length === 2 || arguments.length === 1, 'Expects 1 or 2 arguments, but got ' + arguments.length );
  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );

  if( arguments.length === 1 )
  {
    argument = error;
    error = undefined;
  }

  self.__onTake( error, argument );

  _.timeOut( 1, function timeOut()
  {
    self.take( error, argument );
  });

  return self;
}

/**
 * Method pushes `resource` into wConsequence resources queue.
 * Method also can accept two parameters: error, and
 * Returns current wConsequence instance.
 * @example
 * function gotHandler1( error, value )
   {
     console.log( 'competitor 1: ' + value );
   };

   let con1 = new _.Consequence();

   con1.finallyGive( gotHandler1 );
   con1.take( 'hello' );

   // prints " competitor 1: hello ",
 * @param {*} [resource] Resolved value
 * @returns {wConsequence} consequence current wConsequence instance.
 * @throws {Error} if passed extra parameters.
 * @method take
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function take( error, argument )
{
  let self = this;

  _.assert( arguments.length === 2 || arguments.length === 1, 'Expects 1 or 2 arguments, but got ' + arguments.length );
  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );

  if( arguments.length === 1 )
  {
    argument = error;
    error = undefined;
  }

  // if( error !== undefined )
  // error = _._err( err );

  if( error !== undefined )
  error = self.__handleError( error )

  self.__take( error, argument );

  if( self.AsyncCompetitorHanding || self.AsyncResourceAdding )
  self.__handleResourceSoon( true );
  else
  self.__handleResourceNow();

  return self;
}

take.having =
{
  consequizing : 1,
}

//

/**
 * Using for adds to resource queue error reason, that using for informing corespondent that will handle it, about
 * exception
 * @example
   function showResult(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con = new  _.Consequence();

   function divade( x, y )
   {
     let result;
     if( y!== 0 )
     {
       result = x / y;
       con.take(result);
     }
     else
     {
       con.error( 'divide by zero' );
     }
   }

   con.finallyGive( showResult );
   divade( 3, 0 );

   // prints : handleGot1 error: divide by zero
 * @param {*|Error} error error, or value that represent error reason
 * @throws {Error} if passed extra parameters.
 * @method error
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function error( error )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 0 );

  if( arguments.length === 0  )
  error = _.err();

  if( error !== undefined )
  error = self.__handleError( error )

  self.__take( error, undefined );

  if( self.AsyncCompetitorHanding || self.AsyncResourceAdding )
  self.__handleResourceSoon( true );
  else
  self.__handleResourceNow();

  return self;
}

error.having =
{
  consequizing : 1,
}

// //
//
// /**
//  * Method creates and pushes resource object into wConsequence resources sequence.
//  * Returns current wConsequence instance.
//  * @param {*} error Error value
//  * @param {*} argument resolved value
//  * @returns {_giveWithError}
//  * @private
//  * @throws {Error} if missed arguments or passed extra arguments
//  * @method _giveWithError
//  * @memberof module:Tools/base/Consequence.wConsequence#
//  */
//
// function _giveWithError( error, argument )
// {
//   let self = this;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   return self.__take( error, argument );
// }

//

function __take( error, argument )
{
  let self = this;

  let resource = Object.create( null );
  resource.error = error;
  resource.argument = argument;

  _.assert( error !== undefined || argument !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( error === undefined || argument === undefined, 'Cant take both error and argument, one should be undefined' );
  _.assert( arguments.length === 2 );

  self.__onTake( error, argument );

  if( _.consequenceIs( argument ) )
  {
    debugger;
    argument.finallyGive( self );
    return self;
  }

  if( Config.debug )
  {
    if( !( !self.capacity || self._resources.length < self.capacity ) )
    {
      let args =
      [
        `Resource capacity of ${self.qualifiedName} set to ${self.capacity}, but got more resources.`
        + `\nConsider resetting : "{ capacity : 0 }"`
      ]
      debugger;
      throw _._err({ args : args, stackRemobeBeginExclude : /\bConsequence.s\b/ });
    }
    if( !( error === undefined || argument === undefined ) )
    {
      let args =
      [
        '{-error-} and {-argument-} channels should not be in use simultaneously\n'
        + '{-error-} or {-argument-} should be undefined, but currently '
        + '\n{-error-} is ' + _.strType( error )
        + '\n{-argument-} is ' + _.strType( argument )
      ]
      debugger;
      throw _._err({ args : args, stackRemobeBeginExclude : /\bConsequence.s\b/ });
    }
  }

  self._resources.push( resource );

  return self;
}

//

function __onTake( err, arg )
{
  let self = this;

}

//

// /**
//  * Creates and pushes resource object into wConsequence resources sequence, and trying to get and return result of
//     handling this resource by appropriate competitor.
//  * @example
//    let con = new  _.Consequence();
//
//    function increment( err, value )
//    {
//      return ++value;
//    };
//
//
//    con.finallyGive( increment );
//    let result = con.ping( undefined, 4 );
//    console.log( result );
//    // prints 5;
//  * @param {*} error
//  * @param {*} argument
//  * @returns {*} result
//  * @throws {Error} if missed arguments or passed extra arguments
//  * @method ping
//  * @memberof module:Tools/base/Consequence.wConsequence#
//  */
//
// function _ping( error, argument )
// {
//   let self = this;
//
//   throw _.err( 'deprecated' );
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//   let resource =
//   {
//     error,
//     argument,
//   }
//
//   self._resources.push( resource );
//   let result = self.__handleResourceSoon();
//
//   return result;
// }

// --
// handling mechanism
// --

/**
 * Creates and handles error object based on `err` parameter.
 * Returns new _.Consequence instance with error in resources queue.
 * @param {*} err error value.
 * @returns {wConsequence}
 * @private
 * @method __handleError
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function __handleError( err, competitor )
{
  let self = this;

  err = _._err
  ({
    args : [ err ],
    level : 3,
  });

  if( Config.debug )
  if( competitor && self.Diagnostics && self.Stacking )
  err.stack = err.stack + '\n+\n' + competitor.stack;

  // if( !_.errIsAttended( err ) )
  // _.errAttentionRequest( err );

  if( !_.errIsAttended( err ) )
  {
    _.timeOut( 250, function _unhandledError()
    {
      // debugger;
      if( !_.errIsAttended( err ) )
      {
        debugger;
        err = _.err( err, '\nUnhandled error caught by Consequence!' );
        logger.log( err );
        // _.errLog( err ); /* xxx : make working console.log( err ) */
        debugger;
      }
      return null;
    });

  }

  return err;
}

//

/**
 * Method for processing corespondents and _resources queue. Provides handling of resolved resource values and errors by
    corespondents from competitors value. Method takes first resource from _resources sequence and try to pass it to
    the first corespondent in corespondents sequence. Method returns the result of current corespondent execution.
    There are several cases of __handleResourceSoon behavior:
    - if corespondent is regular function:
      trying to pass resources error and argument values into corespondent and executing. If during execution exception
      occurred, it will be catch by __handleError method. If corespondent was not added by tap or persist method,
      __handleResourceSoon will remove resource from head of queue.

      If corespondent was added by finally, _onceThen, catchKeep, or by other "thenable" method of wConsequence, finally:

      1) if result of corespondents is ordinary value, finally __handleResourceSoon method appends result of corespondent to the
      head of resources queue, and therefore pass it to the next competitor in corespondents queue.
      2) if result of corespondents is instance of wConsequence, __handleResourceSoon will append current wConsequence instance
      to result instance corespondents sequence.

      After method try to handle next resource in queue if exists.

    - if corespondent is instance of wConsequence:
      in that case __handleResourceSoon pass resource into corespondent`s resources queue.

      If corespondent was added by tap, or one of finally, _onceThen, catchKeep, or by other "thenable" method of
      wConsequence finally __handleResourceSoon try to pass current resource to the next competitor in corespondents sequence.

    - if in current wConsequence are present corespondents added by persist method, finally __handleResourceSoon passes resource to
      all of them, without removing them from sequence.

 * @returns {*}
 * @throws {Error} if on invocation moment the _resources queue is empty.
 * @private
 * @method __handleResourceSoon
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function __handleResourceSoon( isResource )
{
  let self = this;
  let async = isResource ? self.AsyncResourceAdding : self.AsyncCompetitorHanding;

  _.assert( _.boolIs( isResource ) );

  if( async )
  {

    if( !self._competitorsEarly.length && !self._competitorsLate.length )
    return;
    if( !self._resources.length )
    return;

    _.timeSoon( () => self.__handleResourceNow() );

  }
  else
  {
    self.__handleResourceNow();
  }

}

//

function __handleResourceNow()
{
  let self = this;
  let counter = 0;

  while( true )
  {

    if( !self._resources.length )
    return;
    if( !self._competitorsEarly.length && !self._competitorsLate.length )
    return;

    /* */

    let resource = self._resources[ 0 ];
    let competitor;
    let isEarly;

    if( self._competitorsEarly.length > 0 )
    {
      competitor = self._competitorsEarly.shift();
      isEarly = true;
    }
    else
    {
      competitor = self._competitorsLate.shift();
      isEarly = false;
    }

    let isConsequence = _.consequenceIs( competitor.competitorRoutine )
    let errorOnly = competitor.kindOfResource === Self.KindOfResource.ErrorOnly;
    let argumentOnly = competitor.kindOfResource === Self.KindOfResource.ArgumentOnly;

    let executing = true;
    executing = executing && ( !errorOnly || ( errorOnly && !!resource.error ) );
    executing = executing && ( !argumentOnly || ( argumentOnly && !resource.error ) );

    if( !executing )
    {
      if( competitor.procedure )
      _.procedure.end( competitor.procedure );
      continue;
    }

    /* resourceReusing */

    _.assert( !!competitor.instant, 'not implemented' );

    let resourceReusing = false;
    resourceReusing = resourceReusing || !executing;
    resourceReusing = resourceReusing || competitor.tapping;
    if( isConsequence && competitor.keeping && competitor.instant )
    resourceReusing = true;

    if( !resourceReusing )
    self._resources.shift();

    /* debug */

    if( Config.debug )
    if( self.Diagnostics )
    {
      if( isConsequence )
      _.arrayRemoveElementOnceStrictly( competitor.competitorRoutine._dependsOf, self );
    }

    if( isConsequence )
    {

      competitor.competitorRoutine.__take( resource.error, resource.argument );

      if( competitor.procedure )
      _.procedure.end( competitor.procedure );

      // if( !competitor.instant && competitor.keeping )
      // debugger;
      // if( !competitor.instant && competitor.keeping )
      // competitor.competitorRoutine._competitorAppend
      // ({
      //   competitorRoutine : self,
      //   keeping : true,
      //   kindOfResource : Self.KindOfResource.Both,
      //   stackLevel : 3,
      //   instant : 1,
      //   late : 1,
      // });

      if( competitor.competitorRoutine.AsyncCompetitorHanding || competitor.competitorRoutine.AsyncResourceAdding )
      competitor.competitorRoutine.__handleResourceSoon( true );
      else
      competitor.competitorRoutine.__handleResourceNow();

    }
    else
    {

      /* call routine */

      let throwenErr = 0;
      let result;

      try
      {
        if( errorOnly )
        result = competitor.competitorRoutine.call( self, resource.error );
        else if( argumentOnly )
        result = competitor.competitorRoutine.call( self, resource.argument );
        else
        result = competitor.competitorRoutine.call( self, resource.error, resource.argument );
      }
      catch( err )
      {
        throwenErr = self.__handleError( err, competitor );
      }

      if( competitor.procedure )
      _.procedure.end( competitor.procedure );

      if( !throwenErr )
      if( competitor.keeping && result === undefined )
      {
        debugger;
        let err = _.err( `Callback of then of consequence should return something, but callback::${competitor.competitorRoutine.name} returned undefined` )
        err = _.err( competitor.competitorRoutine.toString(), '\n', err );
        throwenErr = self.__handleError( err, competitor.competitorRoutine )
      }

      /* keeping */

      if( throwenErr )
      {

        self.__take( throwenErr, undefined );

      }
      else if( competitor.keeping )
      {

        if( _.consequenceIs( result ) )
        {
          result.finally( self );
        }
        else
        {
          self.__take( undefined, result );
        }

      }

    }

    if( self.AsyncCompetitorHanding || self.AsyncResourceAdding )
    return self.__handleResourceSoon( true );

    counter += 1;
  }

}

//

/**
 * Method created and appends competitor object, based on passed options into wConsequence competitors queue.
 *
 * @param {Object} o options object
 * @param {module:Tools/base/Consequence.wConsequence~Competitor|wConsequence} o.competitorRoutine callback
 * @param {Object} [o.context] if defined, it uses as 'this' context in competitor function.
 * @param {Array<*>|ArrayLike} [o.argument] values, that will be used as binding arguments in competitor.
 * @param {boolean} [o.keeping=false] If sets to true, finally result of current competitor will be passed to the next competitor
    in competitors queue.
 * @param {boolean} [o.persistent=false] If sets to true, finally competitor will be work as queue listener ( it will be
 * processed every value resolved by wConsequence).
 * @param {boolean} [o.tapping=false] enabled some breakpoints in debug mode;
 * @returns {wConsequence}
 * @private
 * @method _competitorAppend
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function _competitorAppend( o )
{
  let self = this;
  let competitorRoutine = o.competitorRoutine;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.consequenceIs( self ) );
  _.assert( _.routineIs( competitorRoutine ) || _.consequenceIs( competitorRoutine ), () => 'Expects routine or consequence, but got ' + _.strType( competitorRoutine ) );
  _.assert( o.kindOfResource >= 1 );
  _.assert( competitorRoutine !== self, 'Consquence cant depend on itself' );
  _.assert( o.stackLevel >= 0, 'Competitor should have stack level greater or equal to zero' );
  _.routineOptions( _competitorAppend, o );

  /* */

  if( o.times !== 1 )
  {
    let o2 = _.mapExtend( null, o );
    o2.times = 1;
    for( let t = 0 ; t < o.times ; t++ )
    self._competitorAppend( o2 );
    return;
  }

  let stackLevel = o.stackLevel;
  let competitorDescriptor = o;
  delete competitorDescriptor.times;
  delete competitorDescriptor.stackLevel;

  /* */

  if( Config.debug )
  {

    if( !_.consequenceIs( competitorRoutine ) )
    {
      if( o.kindOfResource === Self.KindOfResource.ErrorOnly )
      _.assert( competitorRoutine.length <= 1, 'ErrorOnly competitor should expect single argument' );
      else if( o.kindOfResource === Self.KindOfResource.ArgumentOnly )
      _.assert( competitorRoutine.length <= 1, 'ArgumentOnly competitor should expect single argument' );
      else if( o.kindOfResource === Self.KindOfResource.Both )
      _.assert( competitorRoutine.length === 0 || competitorRoutine.length === 2, 'Finally competitor should expect two arguments' );
    }

    if( _.consequenceIs( competitorRoutine ) )
    if( self.Diagnostics )
    {
      self.assertNoDeadLockWith( competitorRoutine );
      competitorRoutine._dependsOf.push( self );
    }

    if( self.Diagnostics && self.Stacking )
    {
      competitorDescriptor.stack = _.diagnosticStack([ stackLevel+1, Infinity ]);
    }

  }

  /* procedure */

  // debugger;
  // _.assert( !self._procedure );

  if( !self._procedure )
  self._procedure = new _.Procedure({ _sourcePath : stackLevel+1 });

  _.assert( _.routineIs( o.competitorRoutine ) );

  if( !self._procedure.name() )
  self._procedure.name( o.competitorRoutine.name || '' );

  if( !self._procedure._routine )
  self._procedure._routine = o.competitorRoutine;

  self._procedure.begin();

  competitorDescriptor.procedure = self._procedure;

  self._procedure = null;

  /* */

  // if( o.late === null )
  // o.late = _.consequenceIs( o.competitorRoutine );
  // if( o.late )
  // xxx : implement con1.then( con )

  if( o.late )
  self._competitorsLate.unshift( competitorDescriptor );
  else
  self._competitorsEarly.push( competitorDescriptor );

  return competitorDescriptor;
}

_competitorAppend.defaults =
{
  competitorRoutine : null,
  keeping : null,
  tapping : null,
  kindOfResource : null,
  late : false,
  instant : true,
  // instant : false, // xxx : implement con1.then( con )

  times : 1,
  stackLevel : null,
}

// --
// accounter
// --

function dependencyChainFor( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  return look( self, competitor, [] );

  /* */

  function look( con1, con2, visited )
  {

    if( _.arrayHas( visited, con1 ) )
    return null;
    visited.push( con1 );

    _.assert( _.consequenceIs( con1 ) );

    if( !con1._dependsOf )
    return null;
    if( con1 === con2 )
    return [ con1 ];

    for( let c = 0 ; c < con1._dependsOf.length ; c++ )
    {
      let con1b = con1._dependsOf[ c ];
      if( _.consequenceIs( con1b ) )
      {
        let chain = look( con1b, con2, visited );
        if( chain )
        {
          chain.unshift( con1 );
          return chain;
        }
      }
    }

    return null;
  }

}

//

function doesDependOf( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  let chain = self.dependencyChainFor( competitor );

  return !!chain;

  // if( !self._dependsOf )
  // return false;
  //
  // for( let c = 0 ; c < self._dependsOf.length ; c++ )
  // {
  //   let cor = self._dependsOf[ c ];
  //   if( cor === competitor )
  //   return true;
  //   if( _.consequenceIs( cor ) )
  //   if( cor.doesDependOf( competitor ) )
  //   return true;
  // }
  //
  // return false;
}

//

function assertNoDeadLockWith( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  let result = self.doesDependOf( competitor );

  if( !result )
  return !result;

  return true;
  // logger.log( self.deadLockReport( competitor ) );
  //
  // let msg = 'Dead lock!\n';
  //
  // _.assert( !result, msg );
  //
  // return result;
}

//

function deadLockReport( competitor )
{
  let self = this;

  _.assert( _.consequenceIs( competitor ) );

  let chain = self.dependencyChainFor( competitor );

  if( !chain )
  return '';

  let report = '';

  debugger;
  chain.forEach( ( con ) =>
  {
    if( report )
    report += '\n';
    report += con.qualifiedName + ' : ' + con.sourcePath;
    // report += con.id + ' : ' + con.sourcePath;
  });

  return report;
}

//

function isEmpty()
{
  let self = this;
  if( self.resourcesCount() )
  return false;
  if( self.competitorsCount() )
  return false;
  return true;
}

//

/**
 * Clears all resources and corespondents of wConsequence.
 * @method cancel
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function cancel()
{
  let self = this;
  _.assert( arguments.length === 0 );

  self.competitorsCancel();
  self.resourcesCancel();

  return self;
}

// --
// competitors
// --

function competitorOwn( competitorRoutine )
{
  let self = this;

  _.assert( _.routineIs( competitorRoutine ) );

  for( let c = 0 ; c < self._competitorsEarly.length ; c++ )
  {
    let competitor = self._competitorsEarly[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
  }

  for( let c = 0 ; c < self._competitorsLate.length ; c++ )
  {
    let competitor = self._competitorsLate[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
  }

  return false;
}

//

function competitorHas( competitorRoutine )
{
  let self = this;

  _.assert( _.routineIs( competitorRoutine ) );

  for( let c = 0 ; c < self._competitorsEarly.length ; c++ )
  {
    let competitor = self._competitorsEarly[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
    if( _.consequenceIs( cor ) )
    if( cor.competitorHas( competitorRoutine ) )
    return competitor;
  }

  for( let c = 0 ; c < self._competitorsLate.length ; c++ )
  {
    let competitor = self._competitorsLate[ c ];
    if( competitor.competitorRoutine === competitorRoutine )
    return competitor;
    if( _.consequenceIs( cor ) )
    if( cor.competitorHas( competitorRoutine ) )
    return competitor;
  }

  return false;
}

//

function competitorsCount()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._competitorsEarly.length + self._competitorsLate.length;
}

//

/**
 * The _corespondentMap object
 * @typedef {Object} _corespondentMap
 * @property {Function|wConsequence} competitor function or wConsequence instance, that accepts resolved resources from
 * resources queue.
 * @property {boolean} keeping determines if corespondent pass his result back into resources queue.
 * @property {boolean} tapping determines if corespondent return accepted resource back into  resources queue.
 * @property {boolean} errorOnly turn on corespondent only if resource represent error;
 * @property {boolean} argumentOnly turn on corespondent only if resource represent no error;
 * @property {boolean} debug enables debugging.
 * @property {string} id corespondent id.
 */

/**
 * Returns array of corespondents
 * @example
 * function corespondent1(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   function corespondent2(err, val)
   {
     console.log( 'corespondent2 value: ' + val );
   };

   function corespondent3(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   let con = _.Consequence();

   con.tap( corespondent1 ).finally( corespondent2 ).finallyGive( corespondent3 );

   let corespondents = con.competitorsEarlyGet();

   console.log( corespondents );

 * @returns {_corespondentMap[]}
 * @method competitorsEarlyGet
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function competitorsEarlyGet()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._competitorsEarly;
}

//

function competitorsLateGet()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self._competitorsLate;
}

//

function competitorsGet()
{
  let self = this;
  let r = [];
  _.assert( arguments.length === 0 );
  if( self._competitorsEarly.length )
  _.arrayAppendArray( r, self._competitorsEarly );
  if( self._competitorsLate.length )
  _.arrayAppendArray( r, self._competitorsLate );
  return r;
}

//

/**
 * If called without arguments, method competitorsCancel() removes all corespondents from wConsequence
 * competitors queue.
 * If as argument passed routine, method competitorsCancel() removes it from corespondents queue if exists.
 * @example
 function corespondent1(err, val)
 {
   console.log( 'corespondent1 value: ' + val );
 };

 function corespondent2(err, val)
 {
   console.log( 'corespondent2 value: ' + val );
 };

 function corespondent3(err, val)
 {
   console.log( 'corespondent1 value: ' + val );
 };

 let con = _.Consequence();

 con.finallyGive( corespondent1 ).finallyGive( corespondent2 );
 con.competitorsCancel();

 con.finallyGive( corespondent3 );
 con.take( 'bar' );

 // prints
 // corespondent1 value: bar
 * @param [competitor]
 * @method competitorsCancel
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function competitorsCancel( competitorRoutine )
{
  let self = this;
  let r = 0;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( arguments.length === 0 || _.routineIs( competitorRoutine ) );

  // logger.log( self.toStr() );
  // logger.log( 'competitorsCancel', self.id, self._competitorsEarly.length );
  // debugger;

  if( arguments.length === 0 )
  {

    for( let c = self._competitorsEarly.length - 1 ; c >= 0 ; c-- )
    {
      let competitorDescriptor = self._competitorsEarly[ c ];
      if( competitorDescriptor.procedure )
      _.procedure.end( competitorDescriptor.procedure );
      self._competitorsEarly.splice( c, 1 );
      r += 1;
    }

    for( let c = self._competitorsLate.length - 1 ; c >= 0 ; c-- )
    {
      let competitorDescriptor = self._competitorsLate[ c ];
      if( competitorDescriptor.procedure )
      _.procedure.end( competitorDescriptor.procedure );
      self._competitorsLate.splice( c, 1 );
      r += 1;
    }

  }
  else
  {

    let found = _.arrayLeft( self._competitorsEarly, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
    while( found.element )
    {
      _.assert( found.element.competitorRoutine === competitorRoutine );
      if( found.element.procedure )
      _.procedure.end( found.element.procedure );
      self._competitorsEarly.splice( found.index, 1 )
      found = _.arrayLeft( self._competitorsEarly, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
      r += 1;
    }

    found = _.arrayLeft( self._competitorsLate, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
    while( found.element )
    {
      _.assert( found.element.competitorRoutine === competitorRoutine );
      if( found.element.procedure )
      _.procedure.end( found.element.procedure );
      self._competitorsLate.splice( found.index, 1 )
      found = _.arrayLeft( self._competitorsLate, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
      r += 1;
    }

    _.assert( r > 0, `Found no competitor ${competitorRoutine.name}` );

  }

  return self;
}

// //
//
// function competitorCancel( competitorRoutine )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.routineIs( competitorRoutine ) );
//
//   let found = _.arrayLeft( self._competitorsEarly, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
//   found.container = self._competitorsEarly;
//
//   if( !found.element )
//   {
//     found = _.arrayLeft( self._competitorsLate, competitorRoutine, ( c ) => c.competitorRoutine, ( c ) => c );
//     found.container = self._competitorsLate;
//   }
//
//   if( !found.element )
//   {
//     debugger;
//     let procedure = _.procedure.getSingleMaybe( competitorRoutine );
//     let procedureName = ( procedure ? '\n' + procedure.longName : '' );
//     throw _.err( 'Competitor', _.toStrShort( competitorRoutine ), 'is not on the queue', procedureName );
//   }
//
//   _.assert( found.element.competitorRoutine === competitorRoutine );
//
//   if( found.element.procedure )
//   _.procedure.end( found.element.procedure );
//   found.container.splice( found.index, 1 );
//
//   return self;
// }

//

function argumentsCount()
{
  let self = this;
  return self._resources.filter( ( e ) => e.argument !== undefined ).length;
}

//

function errorsCount()
{
  let self = this;
  return self._resources.filter( ( e ) => e.error !== undefined ).length;
}

//

/**
 * Returns number of resources in current resources queue.
 * @example
 * let con = _.Consequence();

   let conLen = con.resourcesCount();
   console.log( conLen );

   con.take( 'foo' );
   con.take( 'bar' );
   con.error( 'baz' );
   conLen = con.resourcesCount();
   console.log( conLen );

   con.resourcesCancel();

   conLen = con.resourcesCount();
   console.log( conLen );
   // prints: 0, 3, 0;

 * @returns {number}
 * @method resourcesCount
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function resourcesCount()
{
  let self = this;
  return self._resources.length;
}

//
//

/**
 * The internal wConsequence view of resource.
 * @typedef {Object} _resourceObject
 * @property {*} error error value
 * @property {*} argument resolved value
 */

/**
 * Returns resources queue.
 * @example
 * let con = _.Consequence();

   con.take( 'foo' );
   con.take( 'bar ');
   con.error( 'baz' );


   let resources = con.resourcesGet();

   console.log( resources );

   // prints
   // [ { error: null, argument: 'foo' },
   // { error: null, argument: 'bar ' },
   // { error: 'baz', argument: undefined } ]

 * @returns {_resourceObject[]}
 * @method resourcesGet
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function resourcesGet( index )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index !== undefined )
  return self._resources[ index ];
  else
  return self._resources;
}

//

function argumentsGet( index )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index !== undefined )
  return self._resources[ index ].argument;
  else
  return _.filter( self._resources, ( r ) => r.argument ? r.argument : undefined );
}

//

function errorsGet( index )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  _.assert( index === undefined || _.numberIs( index ) );
  if( index !== undefined )
  return self._resources[ index ].error;
  else
  return _.filter( self._resources, ( r ) => r.error ? r.error : undefined );
}

//

/**
 * If called without arguments, method removes all resources from wConsequence
 * competitors queue.
 * If as argument passed value, method resourcesCancel() removes it from resources queue if resources queue contains it.
 * @example
 * let con = _.Consequence();

   con.take( 'foo' );
   con.take( 'bar ');
   con.error( 'baz' );

   con.resourcesCancel();
   let resources = con.resourcesGet();

   console.log( resources );
   // prints: []
 * @param {_resourceObject} arg resource object for removing.
 * @throws {Error} If passed extra arguments.
 * @method competitorsCancel
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function resourcesCancel( arg )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( arguments.length === 0 )
  {
    self._resources.splice( 0, self._resources.length );
  }
  else
  {
    throw _.err( 'not tested' );
    _.arrayRemoveElement( self._resources, arg );
  }

}

// --
// procedure
// --

function procedure( longName )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( self._procedure )
  return self._procedure;

  self._procedure = _.Procedure( longName );

  // if( self._procedure && self._procedure._sourcePath && _.strHas( self._procedure._sourcePath, '\Consequence.s:' ) )
  // debugger;

  return self._procedure;
}

//

function procedureDetach()
{
  let self = this;

  _.assert( arguments.length === 0 );

  // _.assert( arguments.length === 0 || arguments.length === 1 );
  // let procedure = self.procedure( longName );
  // if( self._procedure )
  // debugger;
  // let procedure = self._procedure = self._procedure || self.procedure( longName );

  let procedure = self._procedure;
  self._procedure = null;

  return procedure;
}

// --
// exporter
// --

function _infoExport( o )
{
  let self = this;
  let result = '';

  _.assertRoutineOptions( _infoExport, arguments );

  if( o.verbosity >= 2 )
  {
    result += self.qualifiedName;

    let names = _.select( self.competitorsEarlyGet(), '*/tag' );

    // if( self.id )
    // result += '\n  id : ' + self.id;

    result += '\n  argument resources : ' + self.argumentsCount();
    result += '\n  error resources : ' + self.errorsCount();
    result += '\n  early competitors : ' + self.competitorsEarlyGet().length;
    result += '\n  late competitors : ' + self.competitorsLateGet().length;
    result += '\n  AsyncCompetitorHanding : ' + self.AsyncCompetitorHanding;
    result += '\n  AsyncResourceAdding : ' + self.AsyncResourceAdding;

  }
  else
  {
    if( o.verbosity >= 1 )
    result += self.qualifiedName + ' ';

    result += self.resourcesCount() + ' / ' + self.competitorsCount();
  }

  return result;
}

_infoExport.defaults =
{
  verbosity : 2,
}

//

function infoExport( o )
{
  let self = this;
  o = _.routineOptions( infoExport, arguments );
  return self._infoExport( o );
}

_.routineExtend( infoExport, _infoExport );

//

/**
 * Serializes current wConsequence instance.
 * @example
 * function corespondent1(err, val)
   {
     console.log( 'corespondent1 value: ' + val );
   };

   let con = _.Consequence();
   con.finallyGive( corespondent1 );

   let conStr = con.toStr();

   console.log( conStr );

   con.take( 'foo' );
   con.take( 'bar' );
   con.error( 'baz' );

   conStr = con.toStr();

   console.log( conStr );
   // prints:

   // wConsequence( 0 )
   // resource : 0
   // competitors : 1
   // competitor names : corespondent1

   // corespondent1 value: foo

   // wConsequence( 0 )
   // resource : 2
   // competitors : 0
   // competitor names :

 * @returns {string}
 * @method toStr
 * @memberof module:Tools/base/Consequence.wConsequence#
 */

function toStr()
{
  let self = this;
  return self.infoExport({ verbosity : 9 });
}

//

function toString()
{
  let self = this;
  return self.toStr();
}

//

// /**
//  * Can use as competitor. If `err` is not null, throws exception based on `err`. Returns `arg`.
//  * @callback wConsequence._onDebug
//  * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
//  value no exception occurred, it will be set to null;
//  * @param {*} arg resolved by wConsequence value;
//  * @returns {*}
//  * @memberof module:Tools/base/Consequence.wConsequence#
//  */
//
// function _onDebug( err, arg )
// {
//   debugger;
//   if( err )
//   throw _.err( err );
//   return arg;
// }

// --
// accessor
// --

function AsyncModeSet( mode )
{
  let constr = this.Self;
  _.assert( constr.AsyncCompetitorHanding !== undefined );
  _.assert( mode.length === 2 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  constr.AsyncCompetitorHanding = !!mode[ 0 ];
  constr.AsyncResourceAdding = !!mode[ 1 ];
  return [ constr.AsyncCompetitorHanding, constr.AsyncResourceAdding ];
}

//

function AsyncModeGet( mode )
{
  let constr = this.Self;
  _.assert( constr.AsyncCompetitorHanding !== undefined );
  return [ constr.AsyncCompetitorHanding, constr.AsyncResourceAdding ];
}

//

function qualifiedNameGet()
{
  let result = this.shortName;
  if( this.tag )
  result = result + '::' + this.tag;
  else
  result = result + '::';
  return result;
}

//

function _arrayGetter_functor( name )
{
  let symbol = Symbol.for( name );
  return function _get()
  {
    var self = this;
    if( self[ symbol ] === undefined )
    self[ symbol ] = [];
    return self[ symbol ];
  }
}

//

function _defGetter_functor( name, def )
{
  let symbol = Symbol.for( name );
  return function _get()
  {
    var self = this;
    if( self[ symbol ] === undefined )
    return def;
    return self[ symbol ];
  }
}

//

function __call__()
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  if( arguments.length === 2 )
  self.take( arguments[ 0 ], arguments[ 1 ] );
  else
  self.take( arguments[ 0 ] );

}

// --
// static
// --

function From( src, timeOut )
{
  let con = src;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( timeOut === undefined || _.numberIs( timeOut ) );

  // if( !_.consequenceIs( src ) )
  // {
  //   console.log( '_.promiseLike( src )', _.promiseLike( src ) );
  //   console.log( 'src.then', src.then );
  //   console.log( 'src.catch', src.catch );
  //   // console.log( 'src.reject', src.reject );
  //   // console.log( 'src.resolve', src.resolve );
  // }

  if( _.promiseLike( src ) )
  {
    con = new Self();
    let onFulfilled = ( finallyGive ) => { con.take( finallyGive ); }
    let onRejected = ( err ) => { con.error( err ); }
    src.then( onFulfilled, onRejected );
  }

  if( _.consequenceIs( con ) )
  {
    if( timeOut !== undefined )
    return con.orKeepingSplit( _.timeOutError( timeOut ) );
    return con;
  }

  if( _.errIs( src ) )
  return new Self().error( src );

  return new Self().take( src );
}

//

/**
 * If `consequence` if instance of wConsequence, method pass arg and error if defined to it's resource sequence.
 * If `consequence` is routine, method pass arg as arguments to it and return result.
 * @example
 * function showResult(err, val)
   {
     if( err )
     {
       console.log( 'handleGot1 error: ' + err );
     }
     else
     {
       console.log( 'handleGot1 value: ' + val );
     }
   };

   let con = new  _.Consequence();

   con.finallyGive( showResult );

   _.Consequence.take( con, 'hello world' );
   // prints: handleGot1 value: hello world
 * @param {Function|wConsequence} consequence
 * @param {*} arg argument value
 * @param {*} [error] error value
 * @returns {*}
 * @static
 * @method take
 * @memberof module:Tools/base/Consequence.wConsequence.
 */

function Take( consequence )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );

  let err, finallyGive;
  if( arguments.length === 2 )
  {
    finallyGive = arguments[ 1 ];
  }
  else if( arguments.length === 3 )
  {
    err = arguments[ 1 ];
    finallyGive = arguments[ 2 ];
  }

  let args = [ finallyGive ];

  return _Take
  ({
    consequence,
    context : undefined,
    error : err,
    args,
  });

}

//

  /**
   * If `o.consequence` is instance of wConsequence, method pass o.args and o.error if defined, to it's resource sequence.
   * If `o.consequence` is routine, method pass o.args as arguments to it and return result.
   * @param {Object} o parameters object.
   * @param {Function|wConsequence} o.consequence wConsequence or routine.
   * @param {Array} o.args values for wConsequence resources queue or arguments for routine.
   * @param {*|Error} o.error error value.
   * @returns {*}
   * @private
   * @throws {Error} if missed arguments.
   * @throws {Error} if passed argument is not object.
   * @throws {Error} if o.consequence has unexpected type.
   * @method _Take
   * @memberof module:Tools/base/Consequence.wConsequence#
   */

function _Take( o )
{
  let context;

  // if( !( _.arrayIs( o.args ) && o.args.length <= 1 ) )
  // debugger;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( o ) );
  _.assert( _.arrayIs( o.args ) && o.args.length <= 1, 'not tested' );
  _.assertRoutineOptionsPreservingUndefines( _Take, arguments );

  /* */

  if( _.arrayIs( o.consequence ) )
  {

    for( let i = 0 ; i < o.consequence.length ; i++ )
    {
      let optionsGive = _.mapExtend( null, o );
      optionsGive.consequence = o.consequence[ i ];
      _Take( optionsGive );
    }

  }
  else if( _.consequenceIs( o.consequence ) )
  {

    _.assert( _.arrayIs( o.args ) && o.args.length <= 1 );

    context = o.consequence;

    o.consequence.take( o.error, o.args[ 0 ] );

  }
  else if( _.routineIs( o.consequence ) )
  {

    _.assert( _.arrayIs( o.args ) && o.args.length <= 1 );

    return o.consequence.call( context, o.error, o.args[ 0 ] );

  }
  else throw _.err( 'Unknown type of consequence : ' + _.strType( o.consequence ) );

}

_Take.defaults =
{
  consequence : null,
  context : null,
  error : null,
  args : null,

}

//

  /**
   * If `consequence` if instance of wConsequence, method error to it's resource sequence.
   * If `consequence` is routine, method pass error as arguments to it and return result.
   * @example
   * function showResult(err, val)
     {
       if( err )
       {
         console.log( 'handleGot1 error: ' + err );
       }
       else
       {
         console.log( 'handleGot1 value: ' + val );
       }
     };

     let con = new  _.Consequence();

     con.finallyGive( showResult );

     wConsequence.error( con, 'something wrong' );
   // prints: handleGot1 error: something wrong
   * @param {Function|wConsequence} consequence
   * @param {*} error error value
   * @returns {*}
   * @static
   * @method error
   * @memberof module:Tools/base/Consequence.wConsequence.
   */

function Error( consequence, error )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return _Take
  ({
    consequence,
    context : undefined,
    error,
    args : [],
  });

}

//

function Try( routine )
{
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( routine ) );

  try
  {
    let r = routine();
    return Self.From( r );
  }
  catch( err )
  {
    err = _.err( err );
    return new Self().error( err );
  }

}

//

function AndTake( srcs )
{
  _.assert( !_.instanceIs( this ) )
  _.assert( arguments.length === 1 );
  srcs = _.arrayFlatten( _.arrayAs( srcs ) );

  return _.Consequence().take( null ).andTake( srcs ).then( ( arg ) =>
  {
    _.assert( arg[ arg.length - 1 ] === null );
    arg.splice( arg.length - 1, 1 );
    return arg;
  });
}

//

function AndKeep( srcs )
{
  _.assert( !_.instanceIs( this ) )
  _.assert( arguments.length === 1 );
  srcs = _.arrayFlatten( _.arrayAs( srcs ) );

  return _.Consequence().take( null ).andKeep( srcs ).then( ( arg ) =>
  {
    _.assert( arg[ arg.length - 1 ] === null );
    arg.splice( arg.length - 1, 1 );
    return arg;
  });
}

// //
//
// /**
//  * Works like [take]{@link _.Consequence.take} but accepts also context, that will be sealed to competitor.
//  * @see _.Consequence.take
//  * @param {Function|wConsequence} consequence wConsequence or routine.
//  * @param {Object} context sealed context
//  * @param {*} err error reason
//  * @param {*} finallyGive arguments
//  * @returns {*}
//  * @method GiveWithContextAndError
//  * @memberof module:Tools/base/Consequence.wConsequence#
//  */
//
// function GiveWithContextAndError( consequence, context, err, finallyGive )
// {
//
//   if( err === undefined )
//   err = null;
//
//   console.warn( 'deprecated' );
//   //debugger;
//
//   let args = [ finallyGive ];
//   if( arguments.length > 4 )
//   args = _.longSlice( arguments, 3 );
//
//   return _Take
//   ({
//     consequence,
//     context,
//     error : err,
//     args,
//   });
//
// }

// //
//
// /**
//  * Method accepts competitor callback. Returns special competitor that wrap passed one. Passed corespondent will
//  * be invoked only if handling resource contains error value. Else given resource will be delegate to the next competitor
//  * in wConsequence, to the which result competitor was added.
//  * @param {competitor} errHandler competitor for error
//  * @returns {competitor}
//  * @static
//  * @thorws If missed arguments or passed extra ones.
//  * @method catchKeep
//  * @memberof module:Tools/base/Consequence.wConsequence#
//  * @see {@link module:Tools/base/Consequence.wConsequence#catchKeep}
//  */
//
// function IfErrorThen()
// {
//
//   let onEnd = arguments[ 0 ];
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( this === Self );
//   _.assert( _.routineIs( onEnd ) );
//
//   return function catchKeep( err, arg )
//   {
//
//     _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//     if( err )
//     {
//       return onEnd( err, arg );
//     }
//     else
//     {
//       return new Self().take( arg );
//     }
//
//   }
//
// }
//
// //
//
// /**
//  * Method accepts competitor callback. Returns special competitor that wrap passed one. Passed corespondent will
//  * be invoked only if handling resource does not contain error value. Else given resource with error will be delegate to
//  * the next competitor in wConsequence, to the which result competitor was added.
//  * @param {competitor} vallueHandler resolved resource competitor
//  * @returns {corespondent}
//  * @static
//  * @throws {Error} If missed arguments or passed extra one;
//  * @method thenKeep
//  * @memberof module:Tools/base/Consequence.wConsequence#
//  */
//
// function IfNoErrorThen()
// {
//
//   let onEnd = arguments[ 0 ];
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( this === Self );
//   _.assert( _.routineIs( onEnd ) );
//
//   return function thenKeep( err, arg )
//   {
//
//     _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//     if( !err )
//     {
//       return onEnd( err, arg );
//     }
//     else
//     {
//       return new Self().error( err );
//     }
//
//   }
//
// }

//

/**
 * Can use as competitor. If `err` is not null, throws exception based on `err`. Returns `arg`.
 * @callback PassThru
 * @param {*} err Error object, or any other type, that represent or describe an error reason. If during resolving
 value no exception occurred, it will be set to null;
 * @param {*} arg resolved by wConsequence value;
 * @returns {*}
 * @memberof module:Tools/base/Consequence.wConsequence~
 */

function FinallyPass( err, arg )
{
  _.assert( err !== undefined || arg !== undefined, 'Argument of take should be something, not undefined' );
  _.assert( err === undefined || arg === undefined, 'Cant take both error and argument, one should be undefined' );
  if( err )
  throw err;
  // if( err )
  // throw _.err( err );
  return arg;
}

//

function ThenPass( err, arg )
{
  _.assert( arg !== undefined, 'Expects non-undefined argument' );
  return arg;
}

//

function ExceptPass( err, arg )
{
  _.assert( err !== undefined, 'Expects non-undefined error' );
  throw _.err( err );
}
// --
// experimental
// --

function FunctionWithin( consequence )
{
  let routine = this;
  let args;
  let context;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.consequenceIs( consequence ) );

  consequence.finally( function( err, arg )
  {

    return routine.apply( context, args );

  });

  return function()
  {
    context = this;
    args = arguments;
    return consequence;
  }

}

//

function FunctionThereafter()
{
  let con = new Self();
  let routine = this;
  let args = arguments

  con.finally( function( err, arg )
  {

    return routine.apply( null, args );

  });

  return con;
}

//

if( 0 )
{
  Function.prototype.within = FunctionWithin;
  Function.prototype.thereafter = FunctionThereafter;
}

//

function experimentThereafter()
{
  debugger;

  function f()
  {
    debugger;
    console.log( 'done2' );
  }

  _.timeOut( 5000, console.log.thereafter( 'done' ) );
  _.timeOut( 5000, f.thereafter() );

  debugger;

}

//

function experimentWithin()
{

  debugger;
  let con = _.timeOut( 30000 );
  console.log.within( con ).call( console, 'done' );
  con.finally( function()
  {

    debugger;
    console.log( 'done2' );

  });

}

//

function experimentCall()
{

  let con = new Self();
  con( 123 );
  con.finally( function( err, arg )
  {

    console.log( 'finallyGive :', arg );

  });

  debugger;

}

//

function after( resource )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( arguments.length === 0 || resource !== undefined );

  if( resource !== undefined )
  return _.Consequence.From( resource );
  else
  return new _.Consequence().take( null );

}

// //
//
// function before( consequence )
// {
//   _.assert( arguments.length === 1 );
//   _.assert( arguments.length === 0 || consequence !== undefined );
//   _.assert( 0, 'not tested' );
//
//   let result;
//   if( _.consequenceLike( consequence ) )
//   {
//     consequence = _.Consequence.From( consequence );
//   }
//
//   let result = _.Consequence();
//   result.lateFinally( consequence );
//
//   return result;
// }

/**
 * @typedef {Object} Fields
 * @property {Array} _competitorsEarly=[] Queue of competitor that are penging for resource.
 * @property {Array} _resources=[] Queue of messages that are penging for competitor.
 * @property {wProcedure} _procedure=null Instance of wProcedure.
 * @property {String} tag
 * @property {Number} id Id of current instance
 * @property {Array} _dependsOf=[]
 * @property {Number} capacity=0 Maximal number of resources. Unlimited by default.
 * @property {String} sourcePath Path to source file were wConsequence instance was created.
 * @memberof module:Tools/base/Consequence.wConsequence
*/

// --
// relations
// --

/*
let Composes =
{
  _competitorsEarly : null,
  _competitorsLate : null,
  _resources : null,
  _procedure : null,
  capacity : 1,
}

let ComposesDebug =
{
  tag : '',
  _dependsOf : null,
  sourcePath : null,
}

if( Config.debug )
_.mapExtend( Composes, ComposesDebug );

let Associates =
{
}

let Restricts =
{
}
*/

let Composes =
{
  capacity : 1,
  _resources : null,
}

let ComposesDebug =
{
  tag : '',
  sourcePath : null,
}

if( Config.debug )
_.mapExtend( Composes, ComposesDebug );

let Aggregates =
{
}

let Restricts =
{
  _competitorsEarly : null,
  _competitorsLate : null,
  _procedure : null,
}

let RestrictsDebug =
{
  _dependsOf : null,
}

if( Config.debug )
_.mapExtend( Restricts, RestrictsDebug );

let Medials =
{
  tag : '',
  sourcePath : null,
}

let Statics =
{

  After : after,
  From,
  Take,
  Error,
  Try,

  AndTake,
  AndKeep,

  FinallyPass,
  ThenPass,
  ExceptPass,

  AsyncModeSet,
  AsyncModeGet,

  KindOfResource,
  Diagnostics : 1,
  Stacking : 0,
  AsyncCompetitorHanding : 0,
  AsyncResourceAdding : 0,

  shortName : 'Consequence',

}

let Forbids =
{
  every : 'every',
  mutex : 'mutex',
  mode : 'mode',
  resourcesCounter : 'resourcesCounter',
  _competitor : '_competitor',
  _competitorPersistent : '_competitorPersistent',
  id : 'id',
  dependsOf : 'dependsOf',
}

let Accessors =
{
  competitorNext : 'competitorNext',
  _competitorsEarly : { getter : _arrayGetter_functor( '_competitorsEarly' ) },
  _competitorsLate : { getter : _arrayGetter_functor( '_competitorsLate' ) },
  _resources : { getter : _arrayGetter_functor( '_resources' ) },
  _procedure : { getter : _defGetter_functor( '_procedure', null ) },
  capacity : { getter : _defGetter_functor( 'capacity', 1 ) },
}

let DebugAccessors =
{
  tag : { getter : _defGetter_functor( 'tag', null ) },
  // id : { getter : _defGetter_functor( 'id', null ) },
  sourcePath : { getter : _defGetter_functor( 'sourcePath', null ) },
  _dependsOf : { getter : _arrayGetter_functor( '_dependsOf' ) },
}

if( Config.debug )
_.mapExtend( Accessors, DebugAccessors );

// --
// declare
// --

let Extend =
{

  init,
  is,
  isJoinedWithConsequence,

  // basic

  finallyGive,
  give : finallyGive,
  finallyKeep,
  finally : finallyKeep,

  thenGive,
  ifNoErrorGot : thenGive,
  thenKeep,
  then : thenKeep,
  ifNoErrorThen : thenKeep,

  catchGive,
  catchKeep,
  catch : catchKeep,
  ifErrorThen : catchGive,

  // to promise // qqq : cover please

  _promise,
  finallyPromiseGive,
  finallyPromiseKeep,
  promise : finallyPromiseKeep,
  thenPromiseGive,
  thenPromiseKeep,
  exceptPromiseGive,
  exceptPromiseKeep,

  // deasync // qqq : cover please

  _deasync,
  finallyDeasyncGive,
  finallyDeasyncKeep,
  deasync : finallyDeasyncKeep,
  thenDeasyncGive,
  thenDeasyncKeep,
  exceptDeasyncGive,
  exceptDeasyncKeep,

  // advanced

  _first,
  first,

  split : splitKeep,
  splitKeep,
  splitGive,
  tap,
  exceptLog,
  syncMaybe,
  sync,

  // experimental

  _competitorFinally,
  wait,
  participateGive,
  participateKeep,

  // put

  _put,
  put : thenPutGive,
  putGive,
  putKeep,
  thenPutGive,
  thenPutKeep,

  // time

  _timeOut,
  finnallyTimeOut,
  thenTimeOut,
  exceptTimeOut,
  timeOut : finnallyTimeOut,

  // and

  _and,
  andTake,
  andKeep,
  andKeepAccumulative, /* qqq : cover routine andKeepAccumulative */
  and : andKeepAccumulative,

  // or

  _or,
  thenOrTaking,
  thenOrKeeping,
  orKeepingSplit,
  orTaking,
  orKeeping,
  or : orKeeping,

  // adapter

  // _join,
  // join,
  // seal,
  tolerantCallback,

  // resource

  takeLater,
  takeSoon,
  take,
  error,
  __take,
  __onTake,

  // handling mechanism

  __handleError,
  __handleResourceSoon,
  __handleResourceNow,
  _competitorAppend,

  // accounter

  doesDependOf,
  dependencyChainFor,
  assertNoDeadLockWith,
  deadLockReport,

  isEmpty,
  cancel,

  // competitor

  competitorOwn,
  competitorHas,
  competitorsCount,
  competitorsEarlyGet,
  competitorsLateGet,
  competitorsGet,
  competitorsCancel,
  // competitorCancel,

  // resource

  argumentsCount,
  errorsCount,
  resourcesCount,
  resourcesGet,
  argumentsGet,
  errorsGet,
  resourcesCancel,

  // procedure

  procedure,
  procedureDetach,

  // exporter

  _infoExport,
  infoExport,
  toStr,
  toString,

  // accessor

  AsyncModeSet,
  AsyncModeGet,
  qualifiedNameGet,

  __call__,

  // relations

  Composes,
  Aggregates,
  Restricts,
  Medials,
  Forbids,
  Accessors,

}

//

/* statics should be supplemental not extending */

let Supplement =
{
  Statics,
}

let Tools =
{
  after,
  // before,
}

//

_.classDeclare
({
  cls : wConsequence,
  parent : null,
  extend : Extend,
  supplement : Supplement,
  usingOriginalPrototype : 1,
});

_.Copyable.mixin( wConsequence ); /* xxx : try to remove mixin */

_.mapExtend( _, Tools );
_.mapExtend( _realGlobal_.wTools, Tools );

//

_.assert( _.routineIs( wConsequence.prototype.FinallyPass ) );
_.assert( _.routineIs( wConsequence.FinallyPass ) );
_.assert( _.objectIs( wConsequence.prototype.KindOfResource ) );
_.assert( _.objectIs( wConsequence.KindOfResource ) );
_.assert( _.strDefined( wConsequence.name ) );
_.assert( _.strDefined( wConsequence.shortName ) );
_.assert( _.routineIs( wConsequence.prototype.take ) );

_.assert( _.routineIs( wConsequenceProxy.prototype.FinallyPass ) );
_.assert( _.routineIs( wConsequenceProxy.FinallyPass ) );
_.assert( _.objectIs( wConsequenceProxy.prototype.KindOfResource ) );
_.assert( _.objectIs( wConsequenceProxy.KindOfResource ) );
_.assert( _.strDefined( wConsequenceProxy.name ) );
_.assert( _.strDefined( wConsequenceProxy.shortName ) );
_.assert( _.routineIs( wConsequenceProxy.prototype.take ) );

_.assert( wConsequenceProxy.shortName === 'Consequence' );

// _prepareJoinedWithConsequence(); /* xxx : deprecate _prepareJoinedWithConsequence */

// _.assert( !Self.FieldsOfRelationsGroupsGet );
// _.assert( !Self.prototype.FieldsOfRelationsGroupsGet );
// _.assert( !Self.FieldsOfRelationsGroups );
// _.assert( !Self.prototype.FieldsOfRelationsGroups );

_.assert( !!Self.FieldsOfRelationsGroupsGet );
_.assert( !!Self.prototype.FieldsOfRelationsGroupsGet );
_.assert( !!Self.FieldsOfRelationsGroups );
_.assert( !!Self.prototype.FieldsOfRelationsGroups );
_.assert( _.mapKeys( Self.FieldsOfRelationsGroups ).length );

_.assert( _.mapIs( Self.KindOfResource ) );
_.assert( _.mapIs( Self.prototype.KindOfResource ) );
_.assert( Self.AsyncCompetitorHanding === 0 );
_.assert( Self.prototype.AsyncCompetitorHanding === 0 );

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( !_global_.__GLOBAL_PRIVATE_CONSEQUENCE__ )
_realGlobal_[ Self.name ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
