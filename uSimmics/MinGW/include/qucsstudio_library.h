/***************************************************************************
 * copyright: (C) 2011...2022 by Michael Margraf
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License.
 ***************************************************************************/

#pragma once

class Node;
class Component;
class EqnSystem;
struct tParameter;
struct tSysSimData;

#ifdef BUILD_DLL
  #include <float.h>
  #include <complex>
  typedef std::complex<double> complex;
#endif

#ifdef __cplusplus
extern "C" { // export functions with C linkage
#endif


#ifdef BUILD_DLL

#define TNORM      290.0
#define BOLTZMANN  1.380650524e-23
#define KB_DIV_Q   0.86173433260414314916e-4
#define QELECTRON  1.6021765314e-19
#define LIGHTSPEED 299792458.0
#define Z_FIELD    376.73031346958504364963
#define EPSILON0   8.854187817e-12
#define MU0        12.566370614e-7
#define M_TWO_PI   6.28318530717958647693

#define TO_KELVIN(T)   ((T) + 273.15)
#define TO_RADIAN(P)   ((P) * M_PI/180.0)
#define TO_DEGREE(P)   ((P) * 180.0/M_PI)

// helpers for get simulation type in function (*tEvaluate) (EqnSystem*, freq, time)
#define IS_AC_ANALYSIS              (time == -1.0)
#define IS_DC_ANALYSIS              (time < -1.0)
#define IS_DC_INITIAL              ((time == -4.0) || (time == -5.0))
#define IS_REAL_DC_ANALYSIS        ((time == -2.0) || (time == -4.0))
#define IS_TRANSIENT_ANALYSIS       (freq < 0.0)
#define IS_TRANSIENT_INITIAL        (freq == -2.0)
#define IS_NOT_TRANSIENT_ANALYSIS   (freq >= 0.0)

// indeces for substrate properties
#define SUBST_PERMITTIVITY  0
#define SUBST_HEIGHT        1
#define SUBST_THICKNESS     2
#define SUBST_LOSS_TANGENT  3
#define SUBST_RESISTIVITY   4
#define SUBST_ROUGHNESS     5
#define SUBST_BACKSIDE      6
#define SUBST_MS_MODEL      7
#define SUBST_MS_DISPMODEL  8


struct tSysSimData { // used in system simulation
  double symRate;    // symbol rate, e.g. 40 GBaud/s
  int npSym;         // samples per symbol, e.g. 32
  int numSym;        // number of symbols, e.g. 1024
  double sampleRate; // sample rate = symRate * npSym
};

class Subcircuit;

// Component properties with this description can't be seen by the user.
#define COMP_HIDDENPARAMETER  "|"

// flag for string parameter
#define PARAM_NO_NUMBER  -DBL_MAX

struct tParameter {
  char *string;
  double number;
};


class Node
{
public:
  Node(const char*, Subcircuit*);
 ~Node();

  // The number of the node. It corresponds to the row number of the MNA matrix.
  // This number may be changed during the matrix stamping, because shorted nodes
  // are routed to one node.
  int Number;

  // The number of the node. It corresponds to the row number of the MNA matrix.
  // This number never changes during the simulation. It is used to get the
  // DC bias, because there may be AC shorts that are not DC shorts.
  int origNumber;

  // Pointer to the simulation results.
  complex *data;
  double  *noiseData, *dcData;

  const char *Name;
  Node *next;
  Subcircuit *subCircuit;  // the subcircuit it belongs to

  #define NODEFLAG_WARN_OPEN  1
  #define NODEFLAG_STOREDATA  2
  #define NODEFLAG_HASDRIVER  4
  #define NODEFLAG_DATASIZE   8
  int flag;
};


// component type definition
// Only the 12 least-significant bits contain the component type.
// The more-significant bits contain the version:
// 0 = old QucsStudio 4.3.1 style (not supported anymore)
// 1 = uSimmics 5.8 style (not supported anymore)
// 2 = new uSimmics 5.9 style
enum {  // component type definition
  isLinear        = 0x2010,
  isNonLinear     = 0x2020,
  isVoltSource    = 0x2041,
  isCurrSource    = 0x2042,
  isPowerSource   = 0x2044,
  isCurrentProbe  = 0x2100,
  isVoltageProbe  = 0x2200,
  isModelCard     = 0x2400,
};

class Component
{
public:
  Component(Subcircuit*, char*, int, int, int, int numInputs_=0);
  virtual ~Component();

  Node **Nodes;
  int numNodes, numInternNodes, numInputs;

  tParameter *Parameters;
  int numParameters;

  int type;
  char *Name;
};


class EqnSystem
{
public:
  EqnSystem(int);

  // for linear components
  virtual void _setA(int, Node*, Node*, complex) __attribute__((fastcall));
  virtual void _setG(int, Node*, Node*, complex) __attribute__((fastcall));
  virtual void _setR(int, Node*, Node*, complex) __attribute__((fastcall));
  virtual void _setC(int, Node*, Node*, double, double *initVoltage=0) __attribute__((fastcall));
  virtual void _setL(int, Node*, Node*, Node*, double, double *initCurrent=0) __attribute__((fastcall));
  virtual void _setM(int, Node*, Node*, double) __attribute__((fastcall));
  virtual void _setI(int, Node*, Node*, complex) __attribute__((fastcall));
  virtual void _setDelayedI(int, Node*, Node*, double, double, double*&) __attribute__((fastcall));
  virtual void _getSimInfo(int&, double&) __attribute__((fastcall));

  // G = dI / dV and C = dQ / dV for non-linear components
  virtual void _setIQ(int, Node*, Node*, double, double charge=0.0) __attribute__((fastcall));
  virtual void _setGC(int, Node*, Node*, Node*, Node*, double, double cap=0.0) __attribute__((fastcall));

  // noise current correlation matrix
  virtual void _setNoiseA(int, Node*, Node*, complex) __attribute__((fastcall));
  virtual void _setNoiseG(int, Node*, Node*, complex) __attribute__((fastcall));
  virtual void _setNoiseNG(int, Node*, Node*, complex) __attribute__((fastcall));

  virtual double _getV(int, Node*, Node*) __attribute__((fastcall));

  virtual void _setInternR(int, Node*, Node*, complex) __attribute__((fastcall));
};

#define setA(n1,n2,c)       _setA(0,n1,n2,c)
#define setG(n1,n2,c)       _setG(0,n1,n2,c)
#define setR(n1,n2,c)       _setR(0,n1,n2,c)
#define setInternR(n1,n2,c) _setInternR(0,n1,n2,c)
#define setC(n1,n2, ...)    _setC(0,n1,n2, ##__VA_ARGS__)
#define setL(n1,n2,n3, ...) _setL(0,n1,n2,n3, ##__VA_ARGS__)
#define setM(n1,n2,d)       _setM(0,n1,n2,d)
#define setI(n1,n2,c)       _setI(0,n1,n2,c)
#define setDelayedI(n1,n2,d1,d2,p)  _setDelayedI(0,n1,n2,d1,d2,p)
#define setIQ(n1,n2,d1, ...)        _setIQ(0,n1,n2,d1, ##__VA_ARGS__)
#define setGC(n1,n2,n3,n4,d1, ...)  _setGC(0,n1,n2,n3,n4,d1, ##__VA_ARGS__)
#define setNoiseA(n1,n2,c)   _setNoiseA(0,n1,n2,c)
#define setNoiseG(n1,n2,c)   _setNoiseG(0,n1,n2,c)
#define setNoiseNG(n1,n2,c)  _setNoiseNG(0,n1,n2,c)
#define getV(n1,n2)          _getV(0,n1,n2)
#define getSimInfo(i,d)      _getSimInfo(0,i,d)


#else  // of "BUILD_DLL"

typedef double (Component::*tGetNumber) (tParameter&);
typedef void (Component::*tPrintError) (const char*, ...);
typedef void (Component::*tPrintWarning) (const char*, ...);

class DllComponent;
typedef void* (DllComponent::*tFuncWrapper) (int, int, void*, void*, void*);

#endif

struct tGlobalVar;
typedef void (*tEvaluate) (Component*, Node**, tParameter*, tGlobalVar*, EqnSystem*, double, double);
typedef void (*tEvaluateNoise) (Component*, Node**, tParameter*, tGlobalVar*, EqnSystem*, double);
typedef void (*tEvaluateSystem) (Component*, Node**, tParameter*, tSysSimData*);
typedef double (*tGetFrequency) (Component*, tParameter*, tGlobalVar*);
typedef double (*tGetVoltage) (Component*, tParameter*, tGlobalVar*, double, complex*);

// ****** definition of structures *************************************************

struct tParameterDef {
  const char *name;         // identifier of parameter (e.g. "Temp" for temperature)
  const char *defaultValue; // initial value of parameter
  bool visible;             // shown on schematic or not
  const char *description;  // short description of parameter (one text line)
};

struct tComponentInfo {
  int  type;                  // linear, non-linear, etc.
  const char *modelName;      // unique identifier within this DLL (e.g. "BSIM3")
  const char *description;    // short description of the component (one text line)
  int numNodes;               // number of schematic connections
  int numInternNodes;         // number of internal nodes
  int numInputs;              // number of input nodes (for system simulations only)
  int numParameters;          // number of parameters in list
  tParameterDef *parameters;  // pointer to list of parameter definitions
  int sizeGlobalVars;         // size of global variable buffer in bytes
  char *picture;              // pointer to icon in PNG format
  int  pictureSize;           // size of PNG icon
  int symbolIndex;            // index of parameter determining schematic symbol
  char **symbols;             // pointer to list of schematic symbols
  tEvaluate evaluate;         // pointer to function of analog model
  tEvaluateNoise evalNoise;   // pointer to function of noise model
  tEvaluateSystem evalSystem; // pointer to function of system model
  char *verilogModel;         // pointer to digital Verilog model string
  char *vhdlModel;            // pointer to digital VHDL model string
  tGetVoltage getVoltage;     // pointer to function for source components
  tGetFrequency getFrequency; // pointer to function for source components
};

// version for tQucsDllInfo::version
#define BIN_LIBRARY_VERSION   0x00040000

struct tQucsDllInfo {
  int version;                   // version of DLL format
  const char *libraryName;       // name of this library (e.g. "digital gates")
  tComponentInfo **compInfo;     // pointer to list of component definitions
  tParameter (**substrates)[10]; // pointer to list of substrate parameters
};

// identifiers for the function wrapper
#define FUNC_ID_SIZEDATA         1
#define FUNC_ID_ALLOCDATA        2
#define FUNC_ID_GETDATAMEM       3
#define FUNC_ID_GETSUBSTRATE     4
#define FUNC_ID_GETCOMPINSTANCE  5
#define FUNC_ID_CREATECOMPONENT  6


#ifdef BUILD_DLL

// API functions for components
__declspec(dllexport) Node *GND = 0;
__declspec(dllexport) double (*dllGetNumber)  (Component*,int,tParameter&) __attribute__((fastcall));
__declspec(dllexport) void (*dllPrintError)   (Component*,const char*, ...);
__declspec(dllexport) void (*dllPrintWarning) (Component*,const char*, ...);
__declspec(dllexport) void* (*dllFuncWrapper) (Component*,int,int,int,void*,void*,void*) __attribute__((fastcall));

// DLL export
#define EXPORT __declspec(dllexport)

#define getNumber(num)         ((*dllGetNumber) (theComp,0,num))
#define printError(str, ...)   ((*dllPrintError) (theComp,str, ##__VA_ARGS__))
#define printWarning(str, ...) ((*dllPrintWarning) (theComp,str, ##__VA_ARGS__))
#define getSubstrate(str)      ((tParameter*)(*dllFuncWrapper) (theComp,0,FUNC_ID_GETSUBSTRATE, 0,str,0,0))
#define sizeData()             ((int)(*dllFuncWrapper) (theComp,0,FUNC_ID_SIZEDATA,0,0,0,0))
#define allocData(node,n)      ((complex*)(*dllFuncWrapper) (theComp,0,FUNC_ID_ALLOCDATA,n,node,0,0))
#define getDataMem(node)       ((complex*)(*dllFuncWrapper) (theComp,0,FUNC_ID_GETDATAMEM,n,node,0,0))
#define getCompInstance(model,inst)  ((Component*)(*dllFuncWrapper) (theComp,0,FUNC_ID_GETCOMPINSTANCE, 0,(void*)model,(void*)inst,0))
#define createComponent(model,params,nodes)  ((*dllFuncWrapper) (theComp,0,FUNC_ID_CREATECOMPONENT,0,(void*)model,params,nodes))

#define getSubstrateProperty(params, id)   (params[id].number)

#endif  // of "BUILD_DLL"

#ifdef __cplusplus
} // of extern "C"
#endif
