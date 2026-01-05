import { agent, Exception, Process, time } from "@yao/runtime";

/**
 * Initialize the assistant session
 *
 * @param ctx Context
 */
function Create(input: agent.Input, options: agent.Options): agent.Create {}

/**
 * Process completion of assistant response
 * @param ctx Context
 */
function Done(input: agent.Input, output: agent.Output): agent.Done {}

/**
 * Failback hook
 * @param input
 * @param output
 */
function Failback(input: agent.Input, output: agent.Output): agent.Done {}
