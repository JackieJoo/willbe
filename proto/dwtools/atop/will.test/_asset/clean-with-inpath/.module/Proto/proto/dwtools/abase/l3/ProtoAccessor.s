( function _ModuleForTesting12Accessor_s_() {

'use strict';

let Self = _global_.wModuleForTesting1;
let _global = _global_;
let _ = _global_.wModuleForTesting1;

let _ObjectHasOwnProperty = Object.hasOwnProperty;
let _ObjectPropertyIsEumerable = Object.propertyIsEnumerable;
let _nameFielded = _.nameFielded;

_.assert( _.objectIs( _.field ), 'wModuleForTesting12 needs wModuleForTesting1/staging/dwtools/abase/l1/FieldMapper.s' );
_.assert( _.routineIs( _nameFielded ), 'wModuleForTesting12 needs wModuleForTesting1/staging/dwtools/l3/NameModuleForTesting1.s' );

/**
 * @summary Collection of routines for declaring accessors
 * @namespace "wModuleForTesting1.accessor"
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12
 */

/**
 * @summary Collection of routines for declaring getters
 * @namespace "wModuleForTesting1.accessor.getter"
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12
 */

 /**
 * @summary Collection of routines for declaring setters
 * @namespace "wModuleForTesting1.accessor.setter"
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12
 */

/**
 * @summary Collection of routines for declaring getters and setters
 * @namespace "wModuleForTesting1.accessor.suite"
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12
 */

// --
// fields
// --

/**
 * Accessor defaults
 * @typedef {Object} AccessorDefaults
 * @property {Boolean} [ strict=1 ]
 * @property {Boolean} [ preservingValue=1 ]
 * @property {Boolean} [ prime=1 ]
 * @property {String} [ combining=null ]
 * @property {Boolean} [ readOnly=0 ]
 * @property {Boolean} [ readOnlyProduct=0 ]
 * @property {Boolean} [ enumerable=1 ]
 * @property {Boolean} [ configurable=0 ]
 * @property {Function} [ getter=null ]
 * @property {Function} [ setter=null ]
 * @property {Function} [ suite=null ]
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 **/

let AccessorDefaults =
{

  strict : 1,
  preservingValue : 1,
  prime : 1,
  combining : null,

  readOnly : 0,
  readOnlyProduct : 0,
  enumerable : 1,
  configurable : 0,

  get : null,
  set : null,
  suite : null,


}

// --
// accessor
// --

/**
 * Generates options object for _declare, _accessorDeclareForbid functions.
 * Can be called in three ways:
 * - First by passing all options in one object;
 * - Second by passing object and name options;
 * - Third by passing object, names and message option as third parameter.
 * @param {Object} o - options {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor~AccessorOptions}.
 *
 * @example
 * //returns
 * // { object: [Function],
 * // methods: [Function],
 * // names: { a: 'a', b: 'b' },
 * // message: [ 'set/get call' ] }
 *
 * let Self = function ClassName( o ) { };
 * _.accessor._declare_pre( Self, { a : 'a', b : 'b' }, 'set/get call' );
 *
 * @private
 * @function _declare_pre
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function _declare_pre( routine, args )
{
  let o;

  _.assert( arguments.length === 2 );

  if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else
  {
    o = Object.create( null );
    o.object = args[ 0 ];
    o.names = args[ 1 ];
    _.assert( args.length >= 2 );
  }

  // if( !o.methods )
  // o.methods = o.object;
  // else
  // o.methods = _.mapExtend( null, o.methods );

  // if( !_.arrayIs( o.names ) )
  // o.names = _nameFielded( o.names );
  // else
  // o.names = o.names;

  if( args.length > 2 )
  {
    o.message = _.longSlice( args, 2 );
  }

  if( _.strIs( o.names ) )
  o.names = { [ o.names ] : o.names }

  _.routineOptions( routine, o );
  _.assert( !_.primitiveIs( o.object ), 'Expects object as argument but got', o.object );
  _.assert( _.objectIs( o.names ) || _.arrayIs( o.names ), 'Expects object names as argument but got', o.names );

  return o;
}

//

/**
 * Registers provided accessor.
 * Writes accessor's descriptor into accessors map of the prototype ( o.proto ).
 * Supports several combining methods: `rewrite`, `supplement`, `append`.
 *  * Adds diagnostic information to descriptor if running in debug mode.
 * @param {Object} o - options map
 * @param {String} o.name - accessor's name
 * @param {Object} o.proto - target prototype object
 * @param {String} o.declaratorName
 * @param {Array} o.declaratorArgs
 * @param {String} o.declaratorKind
 * @param {String} o.combining - combining method
 * @private
 * @function _register
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function _register( o )
{

  _.routineOptions( _register, arguments );
  _.assert( _.prototypeIsStandard( o.proto ), 'Expects formal prototype' );
  _.assert( _.strDefined( o.declaratorName ) );
  _.assert( _.arrayIs( o.declaratorArgs ) );
  _.fieldsGroupFor( o.proto, '_Accessors' );

  let accessors = o.proto._Accessors;

  if( o.combining && o.combining !== 'rewrite' && o.combining !== 'supplement' )
  debugger;

  if( Config.debug )
  if( !o.combining )
  {
    let stack = accessors[ o.name ] ? accessors[ o.name ].stack : '';
    _.assert
    (
      !accessors[ o.name ],
      'defined at' + '\n',
      stack,
      '\naccessor', o.name, 'of', o.proto.constructor.name
    );
    if( accessors[ o.name ] )
    debugger;
  }

  _.assert( !o.combining || o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement', 'not supported ( o.combining )', o.combining );
  _.assert( _.strIs( o.name ) );

  if( accessors[ o.name ] && o.combining === 'supplement' )
  return;

  let descriptor =
  {
    name : o.name,
    declaratorName : o.declaratorName,
    declaratorArgs : o.declaratorArgs,
    declaratorKind : o.declaratorKind,
    combining : o.combining,
  }

  if( Config.debug )
  descriptor.stack = _.introspector.stack();

  if( o.combining === 'append' )
  {
    if( _.arrayIs( accessors[ o.name ] ) )
    accessors[ o.name ].push( descriptor );
    else
    accessors[ o.name ] = [ descriptor ];
  }

  accessors[ o.name ] = descriptor;

  return descriptor;
}

_register.defaults =
{
  name : null,
  proto : null,
  declaratorName : null,
  declaratorArgs : null,
  declaratorKind : null,
  combining : 0,
}

//

function _declareAct( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.name ) );
  _.assertRoutineOptions( _declareAct, arguments );

  if( o.combining === 'append' )
  debugger;

  /* */

  let propertyDescriptor = _.propertyDescriptorForAccessor( o.object, o.name );
  if( propertyDescriptor.descriptor )
  {

    _.assert
    (
      _.strIs( o.combining ), () =>
      'overriding of property ' + o.name + '\n' +
      '{-o.combining-} suppose to be ' + _.strQuote( _.accessor.Combining ) + ' if accessor overided, ' +
      'but it is ' + _.strQuote( o.combining )
    );

    _.assert( o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement', 'not implemented' );

    if( o.combining === 'supplement' )
    return;

    _.assert( o.combining === 'rewrite', 'not implemented' );
    _.assert( propertyDescriptor.object !== o.object, () => 'Attempt to redefine own accessor ' + _.strQuote( o.name ) + ' of ' + _.toStrShort( o.object ) );

    // if( o.combining === 'append' )
    // {
    //
    //   debugger;
    //
    //   if( o.methods[ '_' + rawName + 'Set' ] === propertyDescriptor.descriptor.set )
    //   o.methods[ '_' + rawName + 'Set' ] = null;
    //   if( o.methods[ rawName + 'Set' ] === propertyDescriptor.descriptor.set )
    //   o.methods[ rawName + 'Set' ] = null;
    //   if( o.methods[ '_' + rawName + 'Get' ] === propertyDescriptor.descriptor.get )
    //   o.methods[ '_' + rawName + 'Get' ] = null;
    //   if( o.methods[ rawName + 'Get' ] === propertyDescriptor.descriptor.get )
    //   o.methods[ rawName + 'Get' ] = null;
    //
    //   let settrGetterSecond = _methodsMake( o, o.methods, rawName );
    //
    //   if( o.methods[ '_' + rawName + 'Set' ] )
    //   o.methods[ '_' + rawName + 'Set' ] = null;
    //   if( o.methods[ rawName + 'Set' ] )
    //   o.methods[ rawName + 'Set' ] = null;
    //   if( o.methods[ '_' + rawName + 'Get' ] )
    //   o.methods[ '_' + rawName + 'Get' ] = null;
    //   if( o.methods[ rawName + 'Get' ] )
    //   o.methods[ rawName + 'Get' ] = null;
    //
    //   o.methods[ '_' + rawName + 'Set' ] = function appendingSet( src )
    //   {
    //     debugger;
    //     src = propertyDescriptor.descriptor.set.call( this, src );
    //     _.assert( src !== undefined );
    //     return settrGetterSecond.set.call( this, src );
    //   }
    //
    //   o.methods[ '_' + rawName + 'Get' ] = settrGetterSecond.get;
    //
    //   appending = 1;
    // }

  }

  /* */

  // if( o.suite )
  // debugger;

  let suite = _.accessor._methodsMake
  ({
    name : o.name,
    methods : o.methods,
    object : o.object,
    preservingValue : o.preservingValue,
    readOnly : o.readOnly,
    readOnlyProduct : o.readOnlyProduct,
    get : o.get,
    set : o.set,
    suite : o.suite,
  });

  /* */

  if( o.prime )
  {

    let o2 = _.mapExtend( null, o );
    o2.names = o.name;
    if( o2.methods === o2.object )
    o2.methods = Object.create( null );
    o2.object = null;

    if( suite.set )
    o2.methods[ '_' + o.name + 'Set' ] = suite.set;
    if( suite.get )
    o2.methods[ '_' + o.name + 'Get' ] = suite.get;

    _.accessor._register
    ({
      proto : o.object,
      name : o.name,
      declaratorName : 'accessor',
      // declaratorName : null,
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  /* */

  let forbiddenName = '_' + o.name;
  let fieldSymbol = Symbol.for( o.name );

  if( o.preservingValue )
  if( _ObjectHasOwnProperty.call( o.object, o.name ) )
  o.object[ fieldSymbol ] = o.object[ o.name ];

  /* define accessor */

  Object.defineProperty( o.object, o.name,
  {
    set : suite.set,
    get : suite.get,
    enumerable : !!o.enumerable,
    configurable : !!o.configurable,
    // configurable : o.combining === 'append',
  });

  /* forbid underscore field */

  if( o.strict && !propertyDescriptor.descriptor  )
  {

    let m =
    [
      'use Symbol.for( \'' + o.name + '\' ) ',
      'to get direct access to property\'s field, ',
      'not ' + forbiddenName,
    ].join( '' );

    if( !_.prototypeIsStandard( o.object ) || ( _.prototypeIsStandard( o.object ) && !_.prototypeHasField( o.object, forbiddenName ) ) )
    _.accessor.forbid
    ({
      object : o.object,
      names : forbiddenName,
      message : [ m ],
      prime : 0,
      strict : 1,
    });

  }

}

var defaults = _declareAct.defaults = Object.create( AccessorDefaults );

defaults.name = null;
defaults.object = null;
defaults.methods = null;

//

/**
 * Accessor options
 * @typedef {Object} AccessorOptions
 * @property {Object} [ object=null ] - source object wich properties will get getter/setter defined.
 * @property {Object} [ names=null ] - map that that contains names of fields for wich function defines setter/getter.
 * Function uses values( rawName ) of object( o.names ) properties to check if fields of( o.object ) have setter/getter.
 * Example : if( rawName ) is 'a', function searchs for '_aSet' or 'aSet' and same for getter.
 * @property {Object} [ methods=null ] - object where function searchs for existing setter/getter of property.
 * @property {Array} [ message=null ] - setter/getter prints this message when called.
 * @property {Boolean} [ strict=true ] - makes object field private if no getter defined but object must have own constructor.
 * @property {Boolean} [ enumerable=true ] - sets property descriptor enumerable option.
 * @property {Boolean} [ preservingValue=true ] - saves values of existing object properties.
 * @property {Boolean} [ prime=true ]
 * @property {String} [ combining=null ]
 * @property {Boolean} [ readOnly=false ] - if true function doesn't define setter to property.
 * @property {Boolean} [ readOnlyProduct=false ]
 * @property {Boolean} [ configurable=false ]
 * @property {Function} [ getter=null ]
 * @property {Function} [ setter=null ]
 * @property {Function} [ suite=null ]
 *
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 **/

/**
 * Defines set/get functions on source object( o.object ) properties if they dont have them.
 * If property specified by( o.names ) doesn't exist on source( o.object ) function creates it.
 * If ( o.object.constructor.prototype ) has property with getter defined function forbids set/get access
 * to object( o.object ) property. Field can be accessed by use of Symbol.for( rawName ) function,
 * where( rawName ) is value of property from( o.names ) object.
 *
 * @param {Object} o - options {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor~AccessorOptions}.
 *
 * @example
 * let Self = function ClassName( o ) { };
 * let o = _.accessor._declare_pre( Self, { a : 'a', b : 'b' }, [ 'set/get call' ] );
 * _.accessor._declare( o );
 * Self.a = 1; // returns [ 'set/get call' ]
 * Self.b = 2; // returns [ 'set/get call' ]
 * console.log( Self.a );
 * // returns [ 'set/get call' ]
 * // 1
 * console.log( Self.b );
 * // returns [ 'set/get call' ]
 * // 2
 *
 * @function _declare
 * @throws {exception} If( o.object ) is not a Object.
 * @throws {exception} If( o.names ) is not a Object.
 * @throws {exception} If( o.methods ) is not a Object.
 * @throws {exception} If( o.message ) is not a Array.
 * @throws {exception} If( o ) is extented by unknown property.
 * @throws {exception} If( o.strict ) is true and object doesn't have own constructor.
 * @throws {exception} If( o.readOnly ) is true and property has own setter.
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function _declare( o )
{

  _.assertRoutineOptions( _declare, arguments );

  if( _.arrayLike( o.object ) )
  {
    // debugger;
    _.each( o.object, ( object ) =>
    {
      let o2 = _.mapExtend( null, o );
      o2.object = object;
      _declare( o2 );
    });
    // debugger;
    return;
  }

  if( !o.methods )
  o.methods = o.object;

  /* verification */

  _.assert( !_.primitiveIs( o.object ) );
  _.assert( !_.primitiveIs( o.methods ) );

  if( o.strict )
  {

    let has =
    {
      constructor : 'constructor',
    }

    _.assertMapOwnAll( o.object, has );
    _.accessor.forbid
    ({
      object : o.object,
      names : _.DefaultForbiddenNames,
      prime : 0,
      strict : 0,
    });

  }

  // debugger;
  _.assert( _.objectLikeOrRoutine( o.object ), () => 'Expects object {-object-}, but got ' + _.toStrShort( o.object ) );
  _.assert( _.objectIs( o.names ), () => 'Expects object {-names-}, but got ' + _.toStrShort( o.names ) );

  /* */

  for( let n in o.names )
  {

    let o2 = o.names[ n ];

    _.assert( _.strIs( o2 ) || _.objectIs( o2 ) );

    if( _.strIs( o2 ) )
    {
      _.assert( o2 === n, 'map for forbid should have same key and value' );
      o2 = _.mapExtend( null, o );
    }
    else
    {
      _.assertMapHasOnly( o2, _.accessor.AccessorDefaults );
      o2 = _.mapExtend( null, o, o2 );
      _.assert( !!o2.object );
    }

    o2.name = n;
    delete o2.names;

    _.accessor._declareAct( o2 );

  }

}

var defaults = _declare.defaults = Object.create( _declareAct.defaults );
defaults.names = null;

//

/**
 * Short-cut for {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor._declare } function.
 * Defines set/get functions on source object( o.object ) properties if they dont have them.
 * For more details {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor._declare }.
 * Can be called in three ways:
 * - First by passing all options in one object( o );
 * - Second by passing ( object ) and ( names ) options;
 * - Third by passing ( object ), ( names ) and ( message ) option as third parameter.
 *
 * @param {Object} o - options {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor~AccessorOptions}.
 *
 * @example
 * let Self = function ClassName( o ) { };
 * _.accessor.declare( Self, { a : 'a' }, 'set/get call' )
 * Self.a = 1; // set/get call
 * Self.a;
 * // returns
 * // set/get call
 * // 1
 *
 * @function declare
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function accessorDeclare( o )
{
  o = _declare_pre( accessorDeclare, arguments );
  return _declare( o );
}

accessorDeclare.defaults = Object.create( _declare.defaults );

//

/**
 * @summary Declares forbid accessor.
 * @description
 * Forbid accessor throws an Error when user tries to get value of the property.
 * @param {Object} o - options {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor~AccessorOptions}.
 *
 * @example
 * let Self = function ClassName( o ) { };
 * _.accessor.forbid( Self, { a : 'a' } )
 * Self.a; // throw an Error
 *
 * @function accessorForbid
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function accessorForbid( o )
{

  o = _declare_pre( accessorForbid, arguments );

  if( !o.methods )
  o.methods = Object.create( null );

  if( _.arrayLike( o.object ) )
  {
    debugger;
    _.each( o.object, ( object ) =>
    {
      let o2 = _.mapExtend( null, o );
      o2.object = object;
      accessorForbid( o2 );
    });
    debugger;
    return;
  }

  if( _.objectIs( o.names ) )
  o.names = _.mapExtend( null, o.names );

  if( o.combining === 'rewrite' && o.strict === undefined )
  o.strict = 0;

  if( o.prime === null )
  o.prime = _.prototypeIsStandard( o.object );

  /* verification */

  _.assert( _.objectLikeOrRoutine( o.object ), () => 'Expects object {-o.object-} but got ' + _.toStrShort( o.object ) );
  _.assert( _.objectIs( o.names ) || _.arrayIs( o.names ), () => 'Expects object {-o.names-} as argument but got ' + _.toStrShort( o.names ) );

  /* message */

  let _constructor = o.object.constructor || Object.getModuleForTesting12typeOf( o.object );
  _.assert( _.routineIs( _constructor ) || _constructor === null );
  _.assert( _constructor === null || _.strIs( _constructor.name ) || _.strIs( _constructor._name ), 'object should have name' );
  if( !o.protoName )
  o.protoName = ( _constructor ? ( _constructor.name || _constructor._name || '' ) : '' ) + '.';
  if( !o.message )
  o.message = 'is deprecated';
  else
  o.message = _.arrayIs( o.message ) ? o.message.join( ' : ' ) : o.message;

  // if( o.protoName === 'wLoggerTop.' && o.names.Static )
  // debugger;

  // /* _accessorDeclareForbid */
  //
  // let encodedName, rawName;

  /* property */

  if( _.objectIs( o.names ) )
  {

    for( let n in o.names )
    {
      let name = o.names[ n ];
      let o2 = _.mapExtend( null, o );
      o2.fieldName = name;
      _.assert( n === name, 'key and value should be the same' );
      if( !_accessorDeclareForbid( o2 ) )
      delete o.names[ name ];
    }

  }
  else
  {

    let namesArray = o.names;
    o.names = Object.create( null );
    // debugger;
    for( let n = 0 ; n < namesArray.length ; n++ )
    {
      let name = namesArray[ n ];
      // let encodedName = namesArray[ n ];
      // let rawName = namesArray[ n ];
      let o2 = _.mapExtend( null, o );
      o2.fieldName = name;
      // o2.fieldValue = namesArray[ n ];
      // _.assert( n === namesArray[ n ] );
      // names[ encodedName ] = rawName;
      if( _accessorDeclareForbid( o2 ) )
      o.names[ name ] = name;
    }
    // debugger;

  }

  // o.names = names;
  // o.object = object;
  // o.methods = methods;
  o.strict = 0;
  o.prime = 0;

  return _declare( _.mapOnly( o, _declare.defaults ) );
}

var defaults = accessorForbid.defaults = Object.create( _declare.defaults );

defaults.preservingValue = 0;
defaults.enumerable = 0;
defaults.prime = null;
defaults.strict = 1;
defaults.combining = 'rewrite';
defaults.message = null;

//

function _accessorDeclareForbid()
{
  let o = _.routineOptions( _accessorDeclareForbid, arguments );
  let setterName = '_' + o.fieldName + 'Set';
  let getterName = '_' + o.fieldName + 'Get';
  let messageLine = o.protoName + o.fieldName + ' : ' + o.message;

  // if( o.fieldName === 'originPath' )
  // debugger;

  // _.assert( o.fieldName === o.fieldValue );
  _.assert( _.strIs( o.protoName ) );
  _.assert( _.objectIs( o.methods ) );

  /* */

  let propertyDescriptor = _.propertyDescriptorForAccessor( o.object, o.fieldName );
  if( propertyDescriptor.descriptor )
  {
    _.assert( _.strIs( o.combining ), 'accessorForbid : if accessor overided expect ( o.combining ) is', _.accessor.Combining.join() );

    if( _.routineIs( propertyDescriptor.descriptor.get ) && propertyDescriptor.descriptor.get.name === 'forbidden' )
    {
      // delete names[ encodedName ];
      return false;
    }

  }

  /* check fields */

  if( o.strict )
  // if( _ObjectHasOwnProperty.call( o.object, o.fieldName ) )
  if( propertyDescriptor.object === o.object )
  {
    if( _.accessor.ownForbid( o.object, o.fieldName ) )
    {
      // delete names[ encodedName ];
      return false;
    }
    else
    {
      // debugger;
      // let pd = _.propertyDescriptorForAccessor( o.object, '_pathGet' );
      forbidden();
    }
  }

  /* check fields group */

  if( o.strict && _.prototypeIsStandard( o.object ) )
  if( _.prototypeHasField( o.object, o.fieldName ) )
  {
    forbidden();
  }

  /* */

  if( !Object.isExtensible( o.object ) )
  {
    // delete names[ encodedName ];
    return false;
  }

  o.methods[ setterName ] = forbidden;
  o.methods[ getterName ] = forbidden;
  forbidden.isForbid = true;

  /* */

  if( o.prime )
  {

    /* !!! not tested */
    let o2 = _.mapExtend( null, o );
    o2.names = o.fieldName;
    o2.object = null;
    delete o2.protoName;
    delete o2.fieldName;

    _.accessor._register
    ({
      proto : o.object,
      name : o.fieldName,
      declaratorName : 'accessorForbid',
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  /* */

  return true;

  /* */

  function forbidden()
  {
    debugger;
    throw _.err( messageLine );
  }

}

var defaults = _accessorDeclareForbid.defaults = Object.create( accessorForbid.defaults );

defaults.fieldName = null;
// defaults.fieldValue = null;
defaults.protoName = null;

//

/**
 * Checks if source object( object ) has own property( name ) and its forbidden.
 * @param {Object} object - source object
 * @param {String} name - name of the property
 *
 * @example
 * let Self = function ClassName( o ) { };
 * _.accessor.forbid( Self, { a : 'a' } );
 * _.accessor.ownForbid( Self, 'a' ) // returns true
 * _.accessor.ownForbid( Self, 'b' ) // returns false
 *
 * @function accessorForbidOwns
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function accessorForbidOwns( object, name )
{
  if( !_ObjectHasOwnProperty.call( object, name ) )
  return false;

  let descriptor = Object.getOwnPropertyDescriptor( object, name );
  if( _.routineIs( descriptor.get ) && descriptor.get.isForbid )
  {
    return true;
  }
  else
  {
    return false;
  }

}

//

/**
 * @summary Declares read-only accessor( s ).
 * @description Expects two arguments: (object), (names) or single as options map {@link module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor~AccessorOptions}
 *
 * @param {Object} object - target object
 * @param {Object} names - contains names of properties that will get read-only accessor
 *
 * @example
 * var Alpha = function _Alpha(){}
 * _.classDeclare
 * ({
 *   cls : Alpha,
 *   parent : null,
 *   extend : { Composes : { a : null } }
 * });
 * _.accessor.readOnly( Alpha.prototype,{ a : 'a' });
 *
 * @function accessorForbid
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function accessorReadOnly( object, names )
{
  let o = _declare_pre( accessorReadOnly, arguments );
  _.assert( o.readOnly );
  return _declare( o );
}

var defaults = accessorReadOnly.defaults = Object.create( _declare.defaults );

defaults.readOnly = true;

//

/**
 * @summary Supplements target object( dst ) with accessors from source object( src ).
 *
 * @description
 * Both objects should have accessorts map defined.
 * Ignores accessor that is already declared on destination object( dst ).
 *
 * @param {Object} src - source object
 * @param {Object} dst - destination object
 *
 * @throws {Exception} If number of arguments is not supported.
 * @throws {Exception} If combining method of source accessor is unknown.
 * @throws {Exception} If accessor.declaratorArgs is not a Array.
 * @throws {Exception} If one of object doesn't have _Accessors map
 * @function accessorsSupplement
 *
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function accessorsSupplement( dst, src )
{

  _.fieldsGroupFor( dst, '_Accessors' );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _ObjectHasOwnProperty.call( dst, '_Accessors' ), 'accessorsSupplement : dst should has _Accessors map' );
  _.assert( _ObjectHasOwnProperty.call( src, '_Accessors' ), 'accessorsSupplement : src should has _Accessors map' );

  /* */

  function supplement( name, accessor )
  {

    _.assert( _.arrayIs( accessor.declaratorArgs ) );
    _.assert( !accessor.combining || accessor.combining === 'rewrite' || accessor.combining === 'supplement' || accessor.combining === 'append', 'not implemented' );

    if( _.objectIs( dst._Accessors[ name ] ) )
    return;

    if( accessor.declaratorName !== 'accessor' )
    {
      _.assert( _.routineIs( dst[ accessor.declaratorName ] ), 'dst does not have accessor maker', accessor.declaratorName );
      dst[ accessor.declaratorName ].apply( dst, accessor.declaratorArgs );
    }
    else
    {
      _.assert( accessor.declaratorArgs.length === 1 );
      let optionsForAccessor = _.mapExtend( null, accessor.declaratorArgs[ 0 ] );
      optionsForAccessor.object = dst;
      if( !optionsForAccessor.methods )
      optionsForAccessor.methods = dst;
      _.accessor.declare( optionsForAccessor );
    }

  }

  /* */

  for( let a in src._Accessors )
  {

    let accessor = src._Accessors[ a ];

    if( _.objectIs( accessor ) )
    supplement( name, accessor );
    else for( let i = 0 ; i < accessor.length ; i++ )
    supplement( name, accessor[ i ] );

  }

}

//

/**
 * Makes constants properties on object by creating new or replacing existing properties.
 * @param {object} dstModuleForTesting12type - prototype of class which will get new constant property.
 * @param {object} namesObject - name/value map of constants.
 *
 * @example
 * let Self = function ClassName( o ) { };
 * let Constants = { num : 100  };
 * _.constant ( Self.prototype, Constants );
 * console.log( Self.prototype ); // returns { num: 100 }
 * Self.prototype.num = 1;// error assign to read only property
 *
 * @function constant
 * @throws {exception} If no argument provided.
 * @throws {exception} If( dstModuleForTesting12type ) is not a Object.
 * @throws {exception} If( name ) is not a Map.
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function constant( dstModuleForTesting12type, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstModuleForTesting12type ), () => 'dstModuleForTesting12type is needed, but got ' + _.toStrShort( dstModuleForTesting12type ) );

  if( _.containerIs( name ) )
  {
    _.eachKey( name, ( n, v ) =>
    {
      if( value !== undefined )
      _.propertyConstant( dstModuleForTesting12type, n, value );
      else
      _.propertyConstant( dstModuleForTesting12type, n, v );
    });
    return;
  }

  if( value === undefined )
  value = dstModuleForTesting12type[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  // for( let n in name )
  // {
  //   let encodedName = n;
  //   let value = name[ n ];

  Object.defineProperty( dstModuleForTesting12type, name,
  {
    value : value,
    enumerable : true,
    writable : false,
    configurable : true,
  });

}

//

/**
 * @summary Defines hidden property with name( name ) and value( value ) on target object( dstModuleForTesting12type ).
 *
 * @description
 * Property is defined as not enumarable.
 * Also accepts second argument as map of properties.
 * If second argument( name ) is a map and third argument( value ) is also defined, then all properties will have value of last arg.
 *
 * @param {Object} dstModuleForTesting12type - target object
 * @param {String|Object} name - name of property or map of names
 * @param {*} value - destination object
 *
 * @throws {Exception} If number of arguments is not supported.
 * @throws {Exception} If dstModuleForTesting12type is not an Object
 * @function hide
 *
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function hide( dstModuleForTesting12type, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstModuleForTesting12type ), () => 'dstModuleForTesting12type is needed, but got ' + _.toStrShort( dstModuleForTesting12type ) );

  if( _.containerIs( name ) )
  {
    _.eachKey( name, ( n, v ) =>
    {
      if( value !== undefined )
      _.propertyHide( dstModuleForTesting12type, n, value );
      else
      _.propertyHide( dstModuleForTesting12type, n, v );
    });
    return;
  }

  if( value === undefined )
  value = dstModuleForTesting12type[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  // for( let n in name )
  // {
  //   let encodedName = n;
  //   let value = name[ n ];

  Object.defineProperty( dstModuleForTesting12type, name,
  {
    value : value,
    enumerable : false,
    writable : true,
    configurable : true,
  });

}

//

/**
 * Makes properties of object( dstModuleForTesting12type ) read only without changing their values. Uses properties names from argument( namesObject ).
 * Sets undefined for property that not exists on source( dstModuleForTesting12type ).
 * @param {object} dstModuleForTesting12type - prototype of class which properties will get read only state.
 * @param {object|string} namesObject - property name as string/map with properties.
 *
 * @example
 * let Self = function ClassName( o ) { };
 * Self.prototype.num = 100;
 * let ReadOnly = { num : null, num2 : null  };
 * _.restrictReadOnly ( Self.prototype, ReadOnly );
 * console.log( Self.prototype ); // returns { num: 100, num2: undefined }
 * Self.prototype.num2 = 1; // error assign to read only property
 *
 * @function restrictReadOnly
 * @throws {exception} If no argument provided.
 * @throws {exception} If( dstModuleForTesting12type ) is not a Object.
 * @throws {exception} If( namesObject ) is not a Map.
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function restrictReadOnly( dstModuleForTesting12type, namesObject )
{

  if( _.strIs( namesObject ) )
  {
    namesObject = Object.create( null );
    namesObject[ namesObject ] = namesObject;
  }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.objectLikeOrRoutine( dstModuleForTesting12type ), '_.constant :', 'dstModuleForTesting12type is needed :', dstModuleForTesting12type );
  _.assert( _.mapIs( namesObject ), '_.constant :', 'namesObject is needed :', namesObject );

  for( let n in namesObject )
  {

    let encodedName = n;
    let value = namesObject[ n ];

    Object.defineProperty( dstModuleForTesting12type, encodedName,
    {
      value : dstModuleForTesting12type[ n ],
      enumerable : true,
      writable : false,
    });

  }

}

//

/**
 * Returns true if source object( proto ) has accessor with name( name ).
 * @param {Object} proto - target object
 * @param {String} name - name of accessor
 * @function has
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor
 */

function has( proto, name )
{
  let accessors = proto._Accessors;
  if( !accessors )
  return false;
  return !!accessors[ name ];
}

//

function suiteMakerFrom_functor( fop )
{

  if( arguments.length === 2 )
  fop = { getterFunctor : arguments[ 0 ], setterFunctor : arguments[ 1 ] }

  _.routineOptions( suiteMakerFrom_functor, fop );

  let defaults;

  if( fop.getterFunctor )
  defaults = _.mapExtend( null, fop.getterFunctor.defaults );
  else
  defaults = _.mapExtend( null, fop.setterFunctor.defaults );

  // debugger;

  if( fop.getterFunctor && _.entityIdentical )
  _.assert( _.entityIdentical( defaults, _.mapExtend( null, fop.getterFunctor.defaults ) ) );
  if( fop.setterFunctor && _.entityIdentical )
  _.assert( _.entityIdentical( defaults, _.mapExtend( null, fop.setterFunctor.defaults ) ) );

  // debugger;

  accessorMaker.defaults = defaults;

  return accessorMaker;

  /* */

  function accessorMaker( o )
  {
    let r = Object.create( null );
    _.routineOptions( accessorMaker, arguments );
    if( fop.setterFunctor )
    r.set = fop.setterFunctor( o );
    if( fop.getterFunctor )
    r.get = fop.getterFunctor( o );
    return r;
  }

}

suiteMakerFrom_functor.defaults =
{
  getterFunctor : null,
  setterFunctor : null,
}

// --
// getter / setter functors
// --

/**
 * @summary Allows to get read and write access to property of inner container.
 * @param {Object} o
 * @param {String} o.name
 * @param {Number} o.index
 * @param {String} o.storageName
 * @function toElement
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor.suite
 */

// debugger;
// function accessorToElement( o )
function toElement( o )
{
  let r = Object.create( null );

  _.assert( 0, 'not tested' );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( o.names ) );
  _.assert( _.strIs( o.name ) );
  _.assert( _.strIs( o.storageName ) );
  _.assert( _.numberIs( o.index ) );
  _.routineOptions( toElement, o );

  debugger;

  // let names = Object.create( null );
  // for( let n in o.names ) (function()
  // {
    // names[ n ] = n;

    // let arrayName = o.arrayName;
    // let index = o.names[ n ];

    let index = o.index;
    let storageName = o.storageName;
    let name = o.name;
    let aname = _.accessor._propertyGetterSetterNames( name );

    _.assert( _.numberIs( index ) );
    _.assert( index >= 0 );

    // let suite = _.accessor._propertyGetterSetterGet( o.object, n );

    // if( !suite.set )
    r[ aname.setName ] = function accessorToElementSet( src )
    {
      this[ storageName ][ index ] = src;
    }

    // if( !suite.get )
    r[ aname.getName ] = function accessorToElementGet()
    {
      return this[ storageName ][ index ];
    }

  // })();

  // _.accessor.declare
  // ({
  //   object : o.object,
  //   names : names,
  // });

  return r;
}

toElement.defaults =
{
  // object : null,
  name : null,
  index : null,
  storageName : null,
}

//

function setterMapCollection_functor( o )
{

  _.assertMapHasOnly( o, setterMapCollection_functor.defaults );
  _.assert( _.strIs( o.name ) );
  _.assert( _.routineIs( o.elementMaker ) );
  let symbol = Symbol.for( o.name );
  let elementMakerOriginal = o.elementMaker;
  let elementMaker = o.elementMaker;
  let friendField = o.friendField;

  if( friendField )
  elementMaker = function elementMaker( src )
  {
    src[ friendField ] = this;
    return elementMakerOriginal.call( this, src );
  }

  return function _setterMapCollection( src )
  {
    let self = this;

    _.assert( _.objectIs( src ) );

    if( self[ symbol ] )
    {

      if( src !== self[ symbol ] )
      for( let d in self[ symbol ] )
      delete self[ symbol ][ d ];

    }
    else
    {

      self[ symbol ] = Object.create( null );

    }

    for( let d in src )
    {
      if( src[ d ] !== null )
      self[ symbol ][ d ] = elementMaker.call( self, src[ d ] );
    }

    return self[ symbol ];
  }

}

setterMapCollection_functor.defaults =
{
  name : null,
  elementMaker : null,
  friendField : null,
}

//

function setterArrayCollection_functor( o )
{

  if( _.strIs( arguments[ 0 ] ) )
  o = { name : arguments[ 0 ] }

  _.routineOptions( setterArrayCollection_functor, o );
  _.assert( _.strIs( o.name ) );
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( o.elementMaker ) || o.elementMaker === null );

  let symbol = Symbol.for( o.name );
  let elementMaker = o.elementMaker;
  let friendField = o.friendField;

  if( !elementMaker )
  elementMaker = function( src ){ return src }

  let elementMakerOriginal = elementMaker;

  if( friendField )
  elementMaker = function elementMaker( src )
  {
    src[ friendField ] = this;
    return elementMakerOriginal.call( this, src );
  }

  return function _setterArrayCollection( src )
  {
    let self = this;

    _.assert( src !== undefined );
    _.assert( arguments.length === 1 );

    if( src !== null )
    src = _.arrayAs( src );

    _.assert( _.arrayIs( src ) );

    if( self[ symbol ] )
    {

      if( src !== self[ symbol ] )
      self[ symbol ].splice( 0, self[ symbol ].length );

    }
    else
    {

      self[ symbol ] = [];

    }

    if( src === null )
    return self[ symbol ];

    if( src !== self[ symbol ] )
    for( let d = 0 ; d < src.length ; d++ )
    {
      if( src[ d ] !== null )
      self[ symbol ].push( elementMaker.call( self, src[ d ] ) );
    }
    else for( let d = 0 ; d < src.length ; d++ )
    {
      if( src[ d ] !== null )
      src[ d ] = elementMaker.call( self, src[ d ] );
    }

    return self[ symbol ];
  }

}

setterArrayCollection_functor.defaults =
{
  name : null,
  elementMaker : null,
  friendField : null,
}

//

/**
 * Makes a setter that makes a shallow copy of (src) before assigning.
 * @param {Object} o - options map
 * @param {Object} o.name - name of property
 * @returns {Function} Returns setter function.
 * @function own
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor.setter
 */

function setterOwn_functor( op )
{
  let symbol = Symbol.for( op.name );

  _.routineOptions( setterOwn_functor, arguments );

  return function ownSet( src )
  {
    let self = this;

    _.assert( arguments.length === 1 );

    self[ symbol ] = _.entityMake( src );

    return self[ symbol ];
  }

}

setterOwn_functor.defaults =
{
  name : null,
}

//

function setterFriend_functor( o )
{

  let name = _.nameUnfielded( o.name ).coded;
  let friendName = o.friendName;
  let maker = o.maker;
  let symbol = Symbol.for( name );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( name ) );
  _.assert( _.strIs( friendName ) );
  _.assert( _.routineIs( maker ), 'Expects maker {-o.maker-}' );
  _.assertMapHasOnly( o, setterFriend_functor.defaults );

  return function setterFriend( src )
  {

    let self = this;
    _.assert( src === null || _.objectIs( src ), 'setterFriend : expects null or object, but got ' + _.strType( src ) );

    if( !src )
    {

      self[ symbol ] = src;
      return;

    }
    else if( !self[ symbol ] )
    {

      if( _.mapIs( src ) )
      {
        let o2 = Object.create( null );
        o2[ friendName ] = self;
        o2.name = name;
        self[ symbol ] = maker( o2 );
        self[ symbol ].copy( src );
      }
      else
      {
        self[ symbol ] = src;
      }

    }
    else
    {

      if( self[ symbol ] !== src )
      self[ symbol ].copy( src );

    }

    if( self[ symbol ][ friendName ] !== self )
    self[ symbol ][ friendName ] = self;

    return self[ symbol ];
  }

}

setterFriend_functor.defaults =
{
  name : null,
  friendName : null,
  maker : null,
}

//

function setterCopyable_functor( o )
{

  let name = _.nameUnfielded( o.name ).coded;
  let maker = o.maker;
  let symbol = Symbol.for( name );
  let debug = o.debug;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( name ) );
  _.assert( _.routineIs( maker ) );
  _.assertMapHasOnly( o, setterCopyable_functor.defaults );

  return function setterCopyable( data )
  {
    let self = this;

    if( debug )
    debugger;

    if( data === null )
    {
      if( self[ symbol ] && self[ symbol ].finit )
      self[ symbol ].finit();
      self[ symbol ] = null;
      return self[ symbol ];
    }

    if( !_.objectIs( self[ symbol ] ) )
    {

      self[ symbol ] = maker( data );

    }
    else
    {

      if( self[ symbol ] !== data )
      {
        _.assert( _.routineIs( self[ symbol ].copy ) );
        self[ symbol ].copy( data );
      }

    }

    return self[ symbol ];
  }

}

setterCopyable_functor.defaults =
{
  name : null,
  maker : null,
  debug : 0,
}

//

/**
 * Makes a setter that makes a buffer from (src) before assigning.
 * @param {Object} o - options map
 * @param {Object} o.name - name of property
 * @param {Object} o.bufferConstructor - buffer constructor
 * @returns {Function} Returns setter function.
 * @function bufferFrom
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor.setter
 */

function setterBufferFrom_functor( o )
{

  let name = _.nameUnfielded( o.name ).coded;
  let bufferConstructor = o.bufferConstructor;
  let symbol = Symbol.for( name );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( name ) );
  _.assert( _.routineIs( bufferConstructor ) );
  _.routineOptions( setterBufferFrom_functor, o );

  return function setterBufferFrom( data )
  {
    let self = this;

    if( data === null || data === false )
    {
      data = null;
    }
    else
    {
      data = _.bufferFrom({ src : data, bufferConstructor : bufferConstructor });
    }

    self[ symbol ] = data;
    return data;
  }

}

setterBufferFrom_functor.defaults =
{
  name : null,
  bufferConstructor : null,
}

//

function setterChangesTracking_functor( o )
{

  let name = Symbol.for( _.nameUnfielded( o.name ).coded );
  let nameOfChangeFlag = Symbol.for( _.nameUnfielded( o.nameOfChangeFlag ).coded );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( setterChangesTracking_functor, o );

  throw _.err( 'not tested' );

  return function setterChangesTracking( data )
  {
    let self = this;

    if( data === self[ name ] )
    return;

    self[ name ] = data;
    self[ nameOfChangeFlag ] = true;

    return data;
  }

}

setterChangesTracking_functor.defaults =
{
  name : null,
  nameOfChangeFlag : 'needsUpdate',
  bufferConstructor : null,
}

//

/**
 * Makes a setter that is an alias for other property.
 * @param {Object} o - options map
 * @param {Object} o.original - name of source property
 * @param {Object} o.alias - name of alias
 * @returns {Function} Returns setter function.
 * @function alias
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor.setter
 */

function alias_pre( routine, args )
{

  let o = args[ 0 ];
  if( _.strIs( args[ 0 ] ) )
  o = { originalName : args[ 0 ], aliasName : args[ 1 ] }

  _.routineOptions( routine, o );

  if( o.aliasName === null )
  o.aliasName = o.originalName;
  if( o.originalName === null )
  o.originalName = o.aliasName;

  _.assert( args.length === 1 || args.length === 2, 'Expects single argument' );
  _.assert( _.strIs( o.aliasName ) );
  _.assert( _.strIs( o.originalName ) );

  return o;
}

//

function aliasSetter_functor_body( o )
{

  let containerName = o.containerName;
  let originalName = o.originalName;
  let aliasName = o.aliasName;

  _.assertRoutineOptions( aliasSetter_functor_body, arguments );

  if( containerName )
  return function aliasSet( src )
  {
    let self = this;
    self[ containerName ][ originalName ] = src;
    return self[ containerName ][ originalName ];
  }
  else
  return function aliasSet( src )
  {
    let self = this;
    self[ originalName ] = src;
    return self[ originalName ];
  }

}

aliasSetter_functor_body.defaults =
{
  containerName : null,
  originalName : null,
  aliasName : null,
}

let aliasSetter_functor = _.routineFromPreAndBody( alias_pre, aliasSetter_functor_body );

//

/**
 * Makes a getter that is an alias for other property.
 * @param {Object} o - options map
 * @param {Object} o.original - name of source property
 * @param {Object} o.alias - name of alias
 * @returns {Function} Returns getter function.
 * @function alias
 * @memberof module:ModuleForTesting1/base/ModuleForTesting12.wModuleForTesting1.accessor.getter
 */

function aliasGetter_functor_body( o )
{

  let containerName = o.containerName;
  let originalName = o.originalName;
  let aliasName = o.aliasName;

  _.assertRoutineOptions( aliasGetter_functor_body, arguments );

  if( containerName )
  return function aliasGet( src )
  {
    let self = this;
    return self[ containerName ][ originalName ];
  }
  else
  return function aliasSet( src )
  {
    let self = this;
    return self[ originalName ];
  }

}

aliasGetter_functor_body.defaults = Object.create( aliasSetter_functor.defaults );

let aliasGetter_functor = _.routineFromPreAndBody( alias_pre, aliasGetter_functor_body );

//

let aliasAccessor = suiteMakerFrom_functor( aliasGetter_functor_body, aliasSetter_functor );

// //
//
// function getterStorage_functor( o )
// {
//
//   let name = o.name;
//   let fieldName = o.fieldName;
//   let containerName = o.containerName;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.routineOptions( getterStorage_functor, o );
//
//   if( containerName )
//   return function getterStorage( src )
//   {
//     let self = this;
//     return self[ containerName ][ fieldName ];
//   }
//   else
//   return function getterStorage( src )
//   {
//     let self = this;
//     return self[ fieldName ];
//   }
//
// }
//
// getterStorage_functor.defaults =
// {
//   name : null,
//   fieldName : null,
//   containerName : null,
// }

//
//
// function accessorToElement( o )
// {
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.objectIs( o.names ) );
//   _.routineOptions( accessorToElement, o );
//
//   let names = Object.create( null );
//   for( let n in o.names ) (function()
//   {
//     names[ n ] = n;
//
//     let arrayName = o.arrayName;
//     let index = o.names[ n ];
//     _.assert( _.numberIs( index ) );
//     _.assert( index >= 0 );
//
//     let suite = _propertyGetterSetterGet( o.object, n );
//
//     if( !suite.set )
//     o.object[ suite.setName ] = function accessorToElementSet( src )
//     {
//       this[ arrayName ][ index ] = src;
//     }
//
//     if( !suite.get )
//     o.object[ suite.getName ] = function accessorToElementGet()
//     {
//       return this[ arrayName ][ index ];
//     }
//
//   })();
//
//   _.accessor.declare
//   ({
//     object : o.object,
//     names : names,
//   });
//
// }
//
// accessorToElement.defaults =
// {
//   object : null,
//   names : null,
//   arrayName : null,
// }

// --
// fields
// --

let Combining = [ 'rewrite', 'supplement', 'apppend', 'prepend' ];

let DefaultAccessorsMap = Object.create( null );
DefaultAccessorsMap.Accessors = accessorDeclare;
DefaultAccessorsMap.Forbids = accessorForbid;
DefaultAccessorsMap.AccessorsForbid = accessorForbid;
DefaultAccessorsMap.AccessorsReadOnly = accessorReadOnly;

let Forbids =
{
  _ArrayDescriptor : '_ArrayDescriptor',
  ArrayDescriptor : 'ArrayDescriptor',
  _ArrayDescriptors : '_ArrayDescriptors',
  ArrayDescriptors : 'ArrayDescriptors',
  arrays : 'arrays',
  arrayOf : 'arrayOf',
}

// --
// define
// --

let Fields =
{

  AccessorDefaults : AccessorDefaults,
  Combining : Combining,
  DefaultAccessorsMap : DefaultAccessorsMap,

}

//

let Routines =
{

  // accessor

  _declare_pre : _declare_pre,
  _register : _register,
  _declareAct : _declareAct,
  _declare : _declare,

  declare : accessorDeclare,
  forbid : accessorForbid,
  _accessorDeclareForbid : _accessorDeclareForbid,

  ownForbid : accessorForbidOwns,
  readOnly : accessorReadOnly,

  supplement : accessorsSupplement,

  constant : constant,
  hide : hide,
  restrictReadOnly : restrictReadOnly,

  has : has,

  suiteMakerFrom_functor,

}

let GetterSetter =
{

  // accessorToElement : accessorToElement,
  toElement : toElement,

}

let Getter =
{

  alias : aliasGetter_functor_body,
  // storage : getterStorage_functor,

}

let Setter =
{

  mapCollection : setterMapCollection_functor,
  arrayCollection : setterArrayCollection_functor,

  own : setterOwn_functor,
  friend : setterFriend_functor,
  copyable : setterCopyable_functor,
  bufferFrom : setterBufferFrom_functor,
  changesTracking : setterChangesTracking_functor,

  alias : aliasSetter_functor,

}

let Accessor =
{

  alias : aliasAccessor,

}

// --
// extend
// --

_.accessor = _.accessor || Object.create( null );
_.mapExtend( _.accessor, Routines );
_.mapExtend( _.accessor, Fields );

_.accessor.forbid( _, Forbids );
_.accessor.forbid( _.accessor, Forbids );

_.accessor.suite = _.accessor.suite || Object.create( null );
_.mapExtend( _.accessor.suite, GetterSetter );

_.accessor.getter = _.accessor.getter || Object.create( null );
_.mapExtend( _.accessor.getter, Getter );

_.accessor.setter = _.accessor.setter || Object.create( null );
_.mapExtend( _.accessor.setter, Setter );

_.accessor.accessor = _.accessor.accessor || Object.create( null );
_.mapExtend( _.accessor.accessor, Accessor );

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
