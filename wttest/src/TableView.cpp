#include "TableView.hpp"

#include <QtCore/QString>
//#include <Table.hpp>
#include <Wt/WContainerWidget>
#include <Wt/WString>
#include <Wt/WEnvironment>

TableView::TableView(const Wt::WEnvironment& env, Table *t) :
        Wt::WApplication(env),
        table(t) {
    setTitle("Push Test");
    setCssTheme("");
    useStyleSheet("data/style.css");
    enableUpdates(true);

    messageResourceBundle().use(appRoot() + "i18n");

    table->connect(this);

    Wt::WPushButton* button = new Wt::WPushButton("Increment", root());

    sound = new Wt::WSound("data/click.mp3");

    button->clicked().connect(this, &TableView::increment);

    text = new Wt::WText("Number will appear here", root());
}

void TableView::increment() {
    table->increment();
}


void TableView::updateNumber(int i) {
    text->setText(Wt::WString::tr("label") + ": " + QString::number(i).toStdString());
    sound->stop();
    sound->play();
    triggerUpdate();
}
