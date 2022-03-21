$(function () {
    $(".moment-datetime").each(function () {
        var $this = $(this);
        $this.text(
            moment($this.data("datetime")).fromNow()
        ).attr(
            "title", moment($this.data("datetime")).format("DD/MM/YYYY hh:mm")
        )
    })
});
