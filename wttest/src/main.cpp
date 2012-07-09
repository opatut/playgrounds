#include <iostream>
#include <Wt/WApplication>
#include <Wt/WContainerWidget>
#include <Wt/WPushButton>
#include <Wt/WText>
#include <Wt/WLineEdit>

#include <Table.hpp>
#include <TableView.hpp>

#include <unistd.h>
#include <QtCore/QString>

using namespace Wt;

Table* table;

WApplication *createApplication(const WEnvironment& env) {
    return new TableView(env, table);
}

int main(int argc, char **argv) {
    Wt::WServer server(argv[0]);
    table = new Table(server);

    server.setServerConfiguration(argc, argv, WTHTTP_CONFIGURATION);

    server.addEntryPoint(Wt::Application, createApplication); //boost::bind(createApplication, _1, table));

    if (server.start()) {
        int sig = Wt::WServer::waitForShutdown();
        server.stop();
        return sig;
    }
    return 1;

    // WRun(argc, argv, createApplication);
}
