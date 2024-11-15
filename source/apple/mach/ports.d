module apple.mach.ports;
import apple.os;

static if (AppleOS):
extern(C):

public import core.sys.darwin.mach.port;
public import core.sys.darwin.mach.kern_return;
public import core.sys.darwin.mach.semaphore;

/// IPC Space
struct ipc_space;
alias ipc_space_t = ipc_space*;
alias mach_port_name_t = natural_t;

/// Deallocates a mach port
kern_return_t mach_port_deallocate(ipc_space_t space, mach_port_name_t name);