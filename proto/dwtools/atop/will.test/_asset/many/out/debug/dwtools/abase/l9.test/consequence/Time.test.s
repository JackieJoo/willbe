( function _Time_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    var _ = require( '../../../Tools.s' );
  }
  catch( err )
  {
    var _ = require( '../../Tools.s' );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );
  _.include( 'wConsequence' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function timeOut( test )
{
  var c = this;
  var que = new _.Consequence().take( null )

  /* */

  .then( function()
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay, () => null )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, null );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOut( c.delay, () => value )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, value );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay, () => _.timeOut( c.delay ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay, () => { _.timeOut( c.delay ); return null } )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, null );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOut( c.delay, undefined, r, [ c.delay ] )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, c.delay / 2 );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence, first delay greater';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay, _.timeOut( c.delay * 2 ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence, second delay greater';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay*3, _.timeOut( c.delay * 2 ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 3 * c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched serially';
    var timeBefore = _.timeNow();
    var val = 13;

    return _.timeOut( c.delay, () => _.timeOut( c.delay * 2, () => val ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 3-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, val );
      return null;
    })
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched concurrently';
    var timeBefore = _.timeNow();
    var val = 13;

    return _.timeOut( c.delay, _.timeOut( c.delay * 2, () => val ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 2-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, val );
      return null;
    })
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched concurrently';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay, _.timeOut( c.delay * 2, () => _.timeOut( c.delay * 2 ) ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 4-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, _.timeOut );
      return null;
    })
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence + error';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay, _.timeOut( c.delay * 2, () => { throw 'err' } ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.is( _.errIs( err ) );
      test.identical( got, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOut( c.delay );
    t.finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( err, 'stop' );
      test.identical( got, undefined );
      return null;
    })
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    t.finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, undefined );
      test.identical( err, 'stop' );
      test.identical( called, false );
      return null;
    })
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();

    var t = _.timeOut( c.delay, () => null );
    t.give( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, null );
      test.identical( err, undefined );
    });

    return _.timeOut( c.delay + 50, function()
    {
      t.error( 'stop' );
      t.give( ( err, got ) => test.identical( err, 'stop' ) );
      return null;
    });

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'give msg before timeOut';
    var timeBefore = _.timeNow();
    var returnValue = 1;
    var msg = 2;

    var t = _.timeOut( c.delay, () => returnValue );

    return _.timeOut( c.delay / 2, function()
    {
      t.take( msg );
      t.give( ( err, got ) => test.identical( got, msg ) );
      t.give( ( err, got ) =>
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, returnValue );

      })
      return null;
    })

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'stop timer with error + arg, routine passed';
    var timeBefore = _.timeNow();
    var called = false;
    var stop = 'stop';

    var t = _.timeOut( c.delay, () => { called = true } );
    t.finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, undefined );
      test.identical( err, stop );
      test.identical( called, false );
      return null;
    })
    _.timeOut( c.delay / 2, () => { t.take( stop, undefined ); return null; } ); // xxx

    return t;
  })

  /* */

  .then( function()
  {

    test.case = 'could have the second argument';

    let f = function(){ return 'a' };

    test.mustNotThrowError( () => _.timeOut( 0, 'x' ) );
    test.mustNotThrowError( () => _.timeOut( 0, 13 ) );
    test.mustNotThrowError( () => _.timeOut( 0, f ) );

    _.timeOut( 0, 'x' ).finally( ( err, arg ) => test.identical( arg, 'x' ) );
    _.timeOut( 0, 13 ).finally( ( err, arg ) => test.identical( arg, 13 ) );
    _.timeOut( 0, f ).finally( ( err, arg ) => test.identical( arg, 'a' ) );

    return _.timeOut( 50 );
  })

  /* */

  .then( function()
  {

    if( !Config.debug )
    return null;

    debugger;

    test.case = 'delay must be number';
    test.shouldThrowErrorSync( () => _.timeOut( 'x' ) );

    test.case = 'if two arguments provided, second must consequence/routine';
    test.shouldThrowErrorSync( () => _.timeOut() );

    test.case = 'if four arguments provided, third must routine';
    test.shouldThrowErrorSync( () => _.timeOut( 0, {}, 'x', [] ) );

    return null;
  })

  que.tap( ( err, arg ) =>
  {
    debugger;
  });

  return que;
}

timeOut.timeOut = 20000;

//

function timeOutMode01( test )
{
  var c = this;
  var mode = _.Consequence.AsyncModeGet();
  var que = new _.Consequence().take( null )

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    return null;
  })
  .then/*finally*/( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay - c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => null );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( c.delay, () => value );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, _.timeOut );
        test.identical( err, undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay * 13;
    }
    var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, c.delay * 13 );
        test.identical( err, undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got , undefined );
        test.identical( err , 'stop' );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });

    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got, undefined );
        test.identical( err, 'stop' );
        test.identical( called, false );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => null );

    var con = new _.Consequence();
    con.first( t );
    con.then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, null );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })

    return _.timeOut( c.delay + 50, function()
    {
      t.error( 'stop' );
      t.give( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .then/*finally*/( function( arg )
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.AsyncModeSet( mode );
      return null;
    });

  })

  return que;
}

timeOutMode10.timeOut = 30000;

// xxx
//
// function timeOutMode01( test )
// {
//   var c = this;
//   var mode = _.Consequence.AsyncModeGet();
//   var que = new _.Consequence().take( null )
//
//   /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */
//
//   .finally( () =>
//   {
//     _.Consequence.AsyncModeSet([ 0, 1 ]);
//     return null;
//   })
//   .then/*finally*/( function( arg )
//   {
//     debugger;
//     test.case = 'delay only';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay );
//     debugger;
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//
//       debugger;
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay - c.timeAccuracy );
//         test.is( _.routineIs( got ) );
//       });
//       debugger;
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => null );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got , null );
//         test.is( err === undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine that returns a value';
//     var timeBefore = _.timeNow();
//     var value = 'value';
//     var t = _.timeOut( c.delay, () => value );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.is( got === value );
//         test.is( err === undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine that returns a consequence';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.is( _.routineIs( got ));
//         test.is( err === undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine that calls another timeOut';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got, _.timeOut );
//         test.identical( err, undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + context + routine + arguments';
//     var timeBefore = _.timeNow();
//     function r( delay )
//     {
//       return delay * 13;
//     }
//     var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got, c.delay * 13 );
//         test.identical( err, undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'stop timer with error';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay );
//     _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime , c.delay / 2 );
//         test.identical( got , undefined );
//         test.identical( err , 'stop' );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'stop timer with error, routine passed';
//     var timeBefore = _.timeNow();
//     var called = false;
//
//     var t = _.timeOut( c.delay, () => { called = true } );
//     _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
//
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime , c.delay / 2 );
//         test.identical( got, undefined );
//         test.identical( err, 'stop' );
//         test.identical( called, false );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'give err after timeOut';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => null );
//
//     var con = new _.Consequence();
//     con.first( t );
//     con.then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got, null );
//         test.identical( err, undefined );
//       })
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .finally(function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//
//     return _.timeOut( c.delay + 50, function()
//     {
//       t.error( 'stop' );
//       t.give( ( err, got ) => test.identical( err, 'stop' ) );
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .then/*finally*/( function( arg )
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//
//       _.Consequence.AsyncModeSet( mode );
//       return null;
//     });
//
//   })
//
//   return que;
// }
//
// timeOutMode10.timeOut = 30000;
//
// //
//
// function timeOutMode10( test )
// {
//   var c = this;
//   var mode = _.Consequence.AsyncModeGet();
//   var que = new _.Consequence().take( null )
//   /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0, */
//
//   .finally( () =>
//   {
//     _.Consequence.AsyncModeSet([ 1, 0 ])
//     return null;
//   })
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay only';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.is( _.routineIs( got ) );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1, function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => null );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got , null );
//         test.identical( err , undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1, function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine that returns a value';
//     var timeBefore = _.timeNow();
//     var value = 'value';
//     var t = _.timeOut( c.delay, () => value );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.is( got === value );
//         test.identical( err , undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1,function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine that returns a consequence';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.is( _.routineIs( got ));
//         test.identical( err , undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1,function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + routine that calls another timeOut';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => { _.timeOut( c.delay ); return null; } );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got , null );
//         test.identical( err , undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1,function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'delay + context + routine + arguments';
//     var timeBefore = _.timeNow();
//     function r( delay )
//     {
//       return delay / 2;
//     }
//     var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.is( got === c.delay / 2 );
//         test.identical( err , undefined );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1,function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'stop timer with error';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay );
//     _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime , c.delay / 2 );
//         test.identical( got , undefined );
//         test.identical( err , 'stop' );
//         test.identical( t.resourcesGet().length, 0 );
//         test.identical( t.competitorsEarlyGet().length, 0 );
//
//       });
//
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'stop timer with error, routine passed';
//     var timeBefore = _.timeNow();
//     var called = false;
//
//     var t = _.timeOut( c.delay, () => { called = true } );
//     _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
//
//     return new _.Consequence().first( t )
//     .then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime , c.delay / 2 );
//         test.identical( got, undefined );
//         test.identical( err, 'stop' );
//         test.identical( called, false );
//         test.identical( t.resourcesGet().length, 0 );
//         test.identical( t.competitorsEarlyGet().length, 0 );
//       });
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//   })
//
//   /**/
//
//   .then/*finally*/( function( arg )
//   {
//     test.case = 'give err after timeOut';
//     var timeBefore = _.timeNow();
//     var t = _.timeOut( c.delay, () => null );
//
//     var con = new _.Consequence();
//     con.first( t );
//     con.then/*finally*/( function( arg )
//     {
//       t.give( function( err, got )
//       {
//         var elapsedTime = _.timeNow() - timeBefore;
//         test.ge( elapsedTime, c.delay-c.timeAccuracy );
//         test.identical( got, null );
//         test.identical( err, undefined );
//       })
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1,function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//       return null;
//     })
//     .then/*finally*/( function( arg )
//     {
//       t.error( 'stop' );
//       t.give( ( err, got ) => test.identical( err, 'stop' ) );
//       test.identical( t.resourcesGet().length, 1 );
//       test.identical( t.competitorsEarlyGet().length, 1 );
//       return null;
//     })
//     .timeOut( 1,function()
//     {
//       test.identical( t.resourcesGet().length, 0 );
//       test.identical( t.competitorsEarlyGet().length, 0 );
//
//       _.Consequence.AsyncModeSet( mode );
//
//       return null;
//     });
//
//     return con;
//   })
//
//   return que;
// }
//
// timeOutMode01.timeOut = 30000;
//
// xxx

//

function timeOutMode10( test )
{
  var c = this;
  var mode = _.Consequence.AsyncModeGet();
  var que = new _.Consequence().take( null )
  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0, */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 1, 0 ])
    return null;
  })
  .then/*finally*/( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => null );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( c.delay, () => value );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => { _.timeOut( c.delay ); return null; } );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === c.delay / 2 );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
    return new _.Consequence().first( t )
    .finally( function()
    {

      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got , undefined );
        test.identical( err , 'stop' );
        test.identical( t.resourcesGet().length, 0 );
        test.identical( t.competitorsEarlyGet().length, 0 );
      });

      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });

    return new _.Consequence().first( t )
    .finally( function()
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got, undefined );
        test.identical( err, 'stop' );
        test.identical( called, false );
        test.identical( t.resourcesGet().length, 0 );
        test.identical( t.competitorsEarlyGet().length, 0 );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => null );

    var con = new _.Consequence();
    con.first( t );
    con.then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, null );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .then/*finally*/( function( arg )
    {
      t.error( 'stop' );
      t.give( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.AsyncModeSet( mode );

      return null;
    });

    return con;
  })

  return que;
}

timeOutMode01.timeOut = 30000;

//

function timeOutMode11( test )
{
  var c = this;
  var mode = _.Consequence.AsyncModeGet();
  var que = new _.Consequence().take( null )

  /* AsyncResourceAdding : 1, AsyncCompetitorHanding : 1 */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 1, 1 ])
    return null;
  })
  .then/*finally*/( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => null );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( c.delay, () => value );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => { _.timeOut( c.delay );return null; } );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === c.delay / 2 );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });
    return new _.Consequence().first( t )
    .finally( function()
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got , undefined );
        test.identical( err , 'stop' );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true; return null; } );
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; });

    return new _.Consequence().first( t )
    .finally( function()
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got, undefined );
        test.identical( err, 'stop' )
        test.identical( called, false );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then/*finally*/( function( arg )
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => null );

    var con = new _.Consequence();
    con.first( t );
    con.then/*finally*/( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, null );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .then/*finally*/( function( arg )
    {
      t.error( 'stop' );
      t.give( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.AsyncModeSet( mode );
      return null;
    });

    return con;
  })

  return que;
}

timeOutMode11.timeOut = 30000;

//

function timeOutError( test )
{
  var c = this;
  var que = new _.Consequence().take( null )

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay, () => null )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOutError( c.delay, () => value )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  // /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay, () => _.timeOut( c.delay ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay, () => { _.timeOut( c.delay ) } )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOutError( c.delay, undefined, r, [ c.delay ] )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOutError( c.delay, _.timeOut( c.delay * 2 ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 2-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });

  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOutError( c.delay );
    t.finally( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, undefined );
      test.is( !!err );
      test.identical( t.resourcesGet().length, 0 );
      return null;
    })
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; } );

    return t;
  })

  /* */

  .then/*finally*/( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOutError( c.delay, () => { called = true } );
    t.finally( function( err, arg )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( arg, undefined );
      test.identical( err, 'stop' );
      test.identical( called, false );
      test.identical( t.resourcesGet().length, 0 );
      return null;
    })
    _.timeOut( c.delay / 2, () => { t.error( 'stop' ); return null; } );

    return t;
  })

  .finally( function( err,arg )
  {
    return null;
  });

  return que;
}

timeOutError.timeOut = 30000;

//

var Self =
{

  name : 'Tools/Time/' + Math.floor( Math.random()*100000 ),
  silencing : 1,
  enabled : 1,

  context :
  {
    timeAccuracy : 1,
    delay : 200,
  },

  tests :
  {

    timeOut,
    timeOutMode01,
    timeOutMode10,
    timeOutMode11,

    timeOutError,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
