#include "xp-commons/ServerRequest.h"

using namespace server;

namespace request{

  class XPTargetServerRequest : public ServerRequest {

    public:
      XPTargetServerRequest();
      virtual ~XPTargetServerRequest();
      void insertToFileSystem(char *mail,char *args);
  };
 
}

