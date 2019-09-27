(function _Logger_s_() {

'use strict';

/**
 * Class to log data consistently which supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.
  @module Tools/base/Logger
*/

/**
 * @file Logger.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof wPrinterTop === 'undefined' )
  require( '../PrinterTop.s' );

}

//

/**
 * @classdesc Creates a logger for printing colorful and well formatted diagnostic code on server-side or in the browser. Based on [wPrinterTop]{@link wPrinterTop}.
 * @class wLogger
 */
var _global = _global_;
var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = function wLogger( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Logger';

//

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 | arguments.length === 1 );

  Parent.prototype.init.call( self,o );

}

// --
// relations
// --

var Composes =
{
  name : '',
}

var Aggregates =
{
}

var Associates =
{
  // output : console,
  output : null,
}

var Restricts =
{
}

var Statics =
{
}

// --
// declare
// --

var Proto =
{

  init,

  // relations


  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_[ Self.shortName ] = Self;

if( !_global_.logger || !( _global_.logger instanceof Self ) )
_global_.logger = _global_[ 'logger' ] = new Self({ output : console, name : 'global' });

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
