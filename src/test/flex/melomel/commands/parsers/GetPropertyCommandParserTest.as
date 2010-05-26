package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.GetPropertyCommand;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class GetPropertyCommandParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var manager:ObjectProxyManager;
	private var parser:ICommandParser;
	private var command:GetPropertyCommand;

	private var object:Object;
	private var proxy:ObjectProxy;
	
	[Before]
	public function setUp():void
	{
		object = {};
		proxy = new ObjectProxy(object);
		manager = new ObjectProxyManager();
		manager.addItem(proxy);
		parser = new GetPropertyCommandParser(manager);
	}

	[After]
	public function tearDown():void
	{
		parser  = null;
		command = null;
		object  = null;
		proxy   = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Parse
	//-----------------------------

	[Test]
	public function parseWithObjectAndProperty():void
	{
		// Assign actual proxy id to the message
		var message:XML = <get property="name"/>;
		message.@object = proxy.id;

		// Parse message
		command = parser.parse(message) as GetPropertyCommand;
		Assert.assertEquals(command.object, object);
		Assert.assertEquals(command.property, "name");
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidAction():void
	{
		var message:XML = <foo property="name"/>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithNoParametersThrowsError():void
	{
		parser.parse(<get/>);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithMissingObjectThrowsError():void
	{
		parser.parse(<get property="name"/>);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithMissingPropertyThrowsError():void
	{
		var message:XML = <get/>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidObjectProxy():void
	{
		parser.parse(<get object="100000" property="foo"/>);
	}
}
}