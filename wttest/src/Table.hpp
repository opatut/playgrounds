#ifndef TABLE_HPP
#define TABLE_HPP

#include <Wt/WServer>
#include <QtCore/QList>

class TableView;

typedef QList<TableView*> ClientList;

class Table {
public:
    Table(Wt::WServer &server);
    void sendToAll();
    void increment();
    void connect(TableView* client);

    int test;
    ClientList clients;
private:
    Wt::WServer& m_server;
};

#endif // TABLE_HPP
