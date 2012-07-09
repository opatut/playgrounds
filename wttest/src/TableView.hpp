#ifndef TABLEVIEW_CPP
#define TABLEVIEW_CPP

#include <Wt/WApplication>
#include <Wt/WText>
#include <Wt/WSound>
#include <Wt/WPushButton>

#include <Table.hpp>

class TableView : public Wt::WApplication {
public:
    Table* table;
    Wt::WText* text;
    Wt::WSound* sound;

    TableView(const Wt::WEnvironment& env, Table* t);
    void increment();
    void updateNumber(int i);

};


#endif // TABLEVIEW_CPP
