#ifndef YfMediaEditor_h
#define YfMediaEditor_h

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*PCallback)(int type, void* pUserData, void* pReserved);

//create
void YfMediaInit(PCallback cb);

// start_time: seconds
// end_time:   seconds
// return 0: success
int YfMediaSplit(const char *input_filename, const char *output_filename, int start_time, int end_time, int Id);

int YfMediaConcat(const char *input_json, const char *output_filename, int id);

char *YfMediaGetVersion();

#ifdef __cplusplus
}  // extern "C"
#endif

#endif //YfMediaEditor_h
