#include "Table.hpp"
#include <iostream>

#include <TableView.hpp> // forward declaration

#include <boost/function.hpp>
#include <boost/bind.hpp>

Table::Table(Wt::WServer &server) :
        test(0),
        m_server(server)
{}

void Table::sendToAll() {
    // TODO: Mutex lock?
    std::cout << "sending " << test << " to " << clients.length() << std::endl;
    Wt::WApplication *app = Wt::WApplication::instance();

    foreach(TableView* i, clients) {
        if (app && app->sessionId() == i->sessionId())
            i->updateNumber(test);
        else
            m_server.post(i->sessionId(), boost::bind(&TableView::updateNumber, i, test));
    }
}

void Table::increment() {
    test++;
    std::cout << "Incremented to " << test << std::endl;
    sendToAll();
}

void Table::connect(TableView* client) {
    clients.append(client);
}
