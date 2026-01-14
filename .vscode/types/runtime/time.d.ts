
/**
 * Represents the Time interface for scheduling operations.
 */
export interface Time {
    /**
     * Pauses the execution for a specified number of milliseconds.
     * @param ms The time to sleep in milliseconds.
     */
    Sleep(ms: number): void;

    /**
     * Schedules a function to execute after a specific duration.
     * @param ms The time to wait before executing the function, in milliseconds.
     * @param name The name of the process to call.
     * @param args Additional arguments to pass to the process.
     */
    After(ms: number, name: string, ...args: any[]): void;
}

/**
 * Declare the global `time` variable implementing the Time interface.
 */
export declare var time: Time;
